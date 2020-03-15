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

class FirebaseInteration {
  final BuildContext context;

  var _firebaseModel;
  List _databaseEntries;

  FirebaseInteration(this.context) {
    _firebaseModel = Provider.of<FirebaseViewModel>(context, listen: false);
    _databaseEntries = List.from(_firebaseModel.rawEntries);
  }

  static Stream<QuerySnapshot> get stream => Firestore.instance
      .collection(Strings.competitionsText.toLowerCase())
      .snapshots();

  void _updateDatabase({bool pop = true, bool popAgain = false}) {
    if (pop) Navigator.of(context).pop();
    if (popAgain) Navigator.of(context).pop();

    Map<String, dynamic> newData = {Fields.data: _databaseEntries};
    DocumentSnapshot _documentSnapshot = _firebaseModel.document;
    _documentSnapshot.reference.updateData(newData).catchError((_) =>
        Scaffold.of(context).showSnackBar(UIToolkit.snackbar(Strings.failure)));
  }

  /// Remove [currentEntry] from the entries in the database.
  void deleteCompetition(DatabaseEntry currentEntry) {
    _databaseEntries.removeWhere(
        (rawEntry) => currentEntry == DatabaseEntry.fromMap(rawEntry));

    _updateDatabase();
  }

  /// With the form fields, create a database entry, convert to json form and add to
  /// the database.
  void addCompetition(
      GlobalKey<FormState> _formKey,
      DecoratedTextField titleField,
      DecoratedTextField locationField,
      DecoratedTextField oppositionField,
      DecoratedDateTimeField dateTimeField) {
    /// If the form inputs have been validated, add to competitions.
    if (_formKey.currentState.validate()) {
      DatabaseEntry newEntry = DatabaseEntry(
          id: Utils.id,
          title: titleField.controller.value.text,
          location: Location(address: locationField.controller.value.text),
          opposition: oppositionField.controller.value.text,
          holes: [],
          score: Score.fresh,
          date: dateTimeField.controller.value.text.split(" ")[0],
          time: dateTimeField.controller.value.text.split(" ")[1]);

      _databaseEntries.add(newEntry.toJson);

      _updateDatabase();
    }
  }

  /// Updates the competition with the given [currentId].
  ///
  /// The data used to replace the data found in the competition is found within
  /// the input fields.
  void updateCompetition(
      GlobalKey<FormState> _formKey,
      int currentId,
      DecoratedTextField titleField,
      DecoratedTextField locationField,
      DecoratedTextField oppositionField,
      DecoratedDateTimeField dateTimeField) {
    /// If the form inputs have been validated, update the competition.
    if (_formKey.currentState.validate()) {
      for (Map entry in _databaseEntries) {
        if (entry[Fields.id] == currentId) {
          /// This is the competition to be updated.
          entry[Fields.title] = titleField.controller.value.text;
          entry[Fields.location] = locationField.controller.value.text;
          entry[Fields.opposition] = oppositionField.controller.value.text;
          entry[Fields.date] =
              dateTimeField.controller.value.text.split(" ")[0];
          entry[Fields.time] =
              dateTimeField.controller.value.text.split(" ")[1];

          break;
        }
      }

      _updateDatabase();
    }
  }

  /// Remove the hole at the [index] within [DatabaseEntry.holes] at the
  /// competition with the [currentId].
  void deleteHole(int index, int currentId) {
    List newHoles = List();

    /// A list of all holes without the deleted one!
    List<Hole> parsedHoles = List();

    for (Map entry in _databaseEntries) {
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

    _updateDatabase(popAgain: true);
  }

  /// Using the form fields, create a [Hole] and add it to the
  /// competitions holes with the [currentId].
  ///
  /// Furthermore, this must update the [score] field of the database entry
  /// in accordance with the new hole.
  void addHole(
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

      for (Map entry in _databaseEntries) {
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

      _updateDatabase();
    }
  }

  void updateHole(int index, int currentId, Hole updatedHole) {
    List newHoles = List();

    /// A list of all holes with the updated one!
    List<Hole> parsedHoles = List();

    for (Map entry in _databaseEntries) {
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

    _updateDatabase(pop: false);
  }
}
