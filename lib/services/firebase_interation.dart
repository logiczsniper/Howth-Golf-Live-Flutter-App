import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/services/utils.dart';
import 'package:howth_golf_live/services/models.dart';

import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class DataBaseInteraction {
  DataBaseInteraction();

  // static void checkSnapshot<T>(dynamic context, {AsyncSnapshot<T> snapshot}) {
  //   assert(snapshot != null);
  //   assert(context != null);

  //   switch (snapshot.connectionState) {
  //     case ConnectionState.none:
  //       Scaffold.of(context)
  //           .showSnackBar(UIToolkit.snackbar(Strings.noConnection));
  //       break;
  //     case ConnectionState.waiting:
  //       Scaffold.of(context).showSnackBar(UIToolkit.snackbar(Strings.loading));
  //       break;
  //     case ConnectionState.active:
  //     case ConnectionState.done:
  //       break;
  //   }
  // }

  /// TODO: optimize & add catch errors (snackbars).

  static Stream<QuerySnapshot> get stream => Firestore.instance
      .collection(Strings.competitionsText.toLowerCase())
      .snapshots();

  /// Remove [currentEntry] from the entries in the database.
  static void deleteCompetition(
      BuildContext context, DataBaseEntry currentEntry) {
    var _firebaseModel = Provider.of<FirebaseViewModel>(context, listen: false);
    List databaseEntries = List.from(_firebaseModel.rawEntries);
    DocumentSnapshot documentSnapshot = _firebaseModel.document;

    databaseEntries.removeWhere(
        (rawEntry) => currentEntry == DataBaseEntry.fromMap(rawEntry));

    Map<String, dynamic> newData = {'data': databaseEntries};
    documentSnapshot.reference
        .updateData(newData)
        .catchError((_) => Scaffold.of(context)
            .showSnackBar(UIToolkit.snackbar(Strings.failure)))
        .whenComplete(Navigator.of(context).pop);
  }

  /// With the form fields, create a database entry, convert to json form and add to
  /// the database.
  static void addCompetition(
      BuildContext context,
      GlobalKey<FormState> _formKey,
      DecoratedTextField titleField,
      DecoratedTextField locationField,
      DecoratedTextField oppositionField,
      DecoratedDateTimeField dateTimeField) {
    /// If the form inputs have been validated, add to competitions.
    if (_formKey.currentState.validate()) {
      DataBaseEntry newEntry = DataBaseEntry(
          id: Utils.id,
          title: titleField.controller.value.text,
          location: Location(address: locationField.controller.value.text),
          opposition: oppositionField.controller.value.text,
          holes: [],
          score: Score.fresh,
          date: dateTimeField.controller.value.text.split(" ")[0],
          time: dateTimeField.controller.value.text.split(" ")[1]);

      var _firebaseModel =
          Provider.of<FirebaseViewModel>(context, listen: false);
      List databaseEntries = List.from(_firebaseModel.rawEntries);
      DocumentSnapshot documentSnapshot = _firebaseModel.document;

      databaseEntries.add(newEntry.toJson);
      Map<String, dynamic> newData = {'data': databaseEntries};
      documentSnapshot.reference
          .updateData(newData)
          .whenComplete(Navigator.of(context).pop);
    }
  }

  /// Remove the hole at the [index] within [DataBaseEntry.holes] at the
  /// competition with the [currentId].
  static void deleteHole(BuildContext context, int index, int currentId) {
    var _firebaseModel = Provider.of<FirebaseViewModel>(context, listen: false);
    List databaseEntries = List.from(_firebaseModel.rawEntries);
    DocumentSnapshot documentSnapshot = _firebaseModel.document;

    List newHoles = List();

    /// A list of all holes without the deleted one!
    List<Hole> parsedHoles = List();

    for (Map entry in databaseEntries) {
      if (entry[Fields.id] == currentId) {
        /// This is the competition which contains the hole to be removed.
        for (int i = 0; i < entry[Fields.holes].length; i++) {
          var hole = entry[Fields.holes][i];
          if (i != index) {
            /// This is NOT the hole that will be removed. Add to holes.
            newHoles.add(hole);
            parsedHoles.add(Hole.fromMap(hole));
          }
        }
        entry[Fields.holes] = newHoles;

        /// Updating the score.
        Score newScore = Score.fromParsedHoles(parsedHoles);

        entry[Fields.score] = newScore.toJson;
        break;
      }
    }

    Map<String, dynamic> newData = {'data': databaseEntries};
    documentSnapshot.reference
        .updateData(newData)
        .whenComplete(Navigator.of(context).pop);
  }

  /// Using the form fields, create a [Hole] and add it to the
  /// competitions holes with the [currentId].
  ///
  /// Furthermore, this must update the [score] field of the database entry
  /// in accordance with the new hole.
  static void addHole(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    DecoratedTextField numberField,
    DecoratedTextField commentField,
    DecoratedTextField howthScoreField,
    DecoratedTextField oppositionScoreField,
    String scoreStatus,
    DecoratedTextField playersField,
    int currentId,
  ) {
    /// If the form inputs have been validated, add to holes.
    if (_formKey.currentState.validate()) {
      Hole newHole = Hole(
        holeNumber: int.tryParse(numberField.controller.value.text),
        holeScore: scoreStatus == "A\\S"
            ? Score.fresh
            : Score(
                howth: howthScoreField.controller.text,
                opposition: oppositionScoreField.controller.text),
        comment: commentField.controller.text,
        lastUpdated: DateTime.now(),

        /// Note: this means that the text provided by the user which contains
        /// player names must be separated with ", " between each player.
        players: playersField.controller.value.text.split(", "),
      );

      var _firebaseModel =
          Provider.of<FirebaseViewModel>(context, listen: false);
      DocumentSnapshot documentSnapshot = _firebaseModel.document;
      List databaseEntries = List.from(_firebaseModel.rawEntries);

      for (Map entry in databaseEntries) {
        if (entry[Fields.id] == currentId) {
          /// This entry is the competition of which this hole must be added to.
          ///
          /// Cannot simply add to the list of holes as it is fixed length.
          /// Thus, a new holes list must be made.
          List newHoles = List();

          /// A list of all holes including the new one!
          List<Hole> parsedHoles = List();

          for (var hole in entry[Fields.holes]) {
            newHoles.add(hole);
            parsedHoles.add(Hole.fromMap(hole));
          }

          newHoles.add(newHole.toJson);
          parsedHoles.add(newHole);

          entry[Fields.holes] = newHoles;

          /// Updating the score.
          Score newScore = Score.fromParsedHoles(parsedHoles);

          entry[Fields.score] = newScore.toJson;
          break;
        }
      }

      Map<String, List> newData = {'data': databaseEntries};
      documentSnapshot.reference
          .updateData(newData)
          .catchError((_) => Scaffold.of(context)
              .showSnackBar(UIToolkit.snackbar(Strings.failure)))
          .whenComplete(Navigator.of(context).pop);
    }
  }

  static void updateHole(
      BuildContext context, int index, int currentId, Hole updatedHole) {
    var _firebaseModel = Provider.of<FirebaseViewModel>(context, listen: false);
    DocumentSnapshot documentSnapshot = _firebaseModel.document;
    List databaseEntries = List.from(_firebaseModel.rawEntries);

    List newHoles = List();

    /// A list of all holes with the updated one!
    List<Hole> parsedHoles = List();

    for (Map entry in databaseEntries) {
      if (entry[Fields.id] == currentId) {
        /// This is the competition which contains the hole to be updated.
        for (int i = 0; i < entry[Fields.holes].length; i++) {
          var hole = entry[Fields.holes][i];
          if (i == index) {
            /// This is the hole that will be updated.
            newHoles.add(updatedHole.toJson);
            parsedHoles.add(updatedHole);
          } else {
            /// This is not the hole to be updated. Add as regular, do
            /// not modify.
            newHoles.add(hole);
            parsedHoles.add(Hole.fromMap(hole));
          }
        }
        entry[Fields.holes] = newHoles;

        /// Updating the score.
        Score newScore = Score.fromParsedHoles(parsedHoles);

        entry[Fields.score] = newScore.toJson;
        break;
      }
    }

    Map<String, dynamic> newData = {'data': databaseEntries};
    documentSnapshot.reference.updateData(newData);
  }
}
