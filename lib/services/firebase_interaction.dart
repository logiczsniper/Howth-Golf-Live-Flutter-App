import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/services/models.dart';

import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class FirebaseInteraction {
  final BuildContext context;

  var _firebaseModel;
  List _databaseEntries;

  FirebaseInteraction.of(this.context) {
    _firebaseModel = Provider.of<FirebaseViewModel>(context, listen: false);
    _databaseEntries = List.from(_firebaseModel.rawEntries);
  }

  static Stream<QuerySnapshot> get stream => Firestore.instance
      .collection(Strings.competitionsText.toLowerCase())
      .snapshots();

  /// Generates a 6 digit id using [Random].
  ///
  /// Appends each new value to a string before parsing the
  /// final value. Does not allow 0 to be the first value in the
  /// [code] as when this is parsed, the 0 will be lost.
  int get _id {
    String code = Strings.empty;
    final Random randomIntGenerator = Random();

    for (int i = 0; i < 6; i++) {
      int nextInt = randomIntGenerator.nextInt(10);
      if (nextInt == 0 && code.isEmpty) {
        i -= 1;
        continue;
      }
      code += nextInt.toString();
    }
    return int.parse(code);
  }

  /// Use [updateData] method to make the changes to [Firestore]
  /// and pop from the stack.
  void _updateDatabase({bool pop = true}) {
    if (pop) Navigator.of(context).pop();

    Map<String, dynamic> newData = {Fields.data: _databaseEntries};
    DocumentSnapshot _documentSnapshot = _firebaseModel.document;
    _documentSnapshot.reference.updateData(newData).catchError((_) =>
        Scaffold.of(context)
            .showSnackBar(UIToolkit.snackbar(Strings.failure, Icons.error)));
  }

  /// Remove [currentEntry] from the entries in the database.
  void deleteCompetition(int id) {
    _databaseEntries.removeWhere((rawEntry) => id == rawEntry[Fields.id]);

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
        id: _id,
        title: titleField.controller.value.text,
        opposition: oppositionField.controller.value.text,
        holes: [],
        score: Score.fresh,
        date: dateTimeField.controller.value.text.split(" ")[0],
        time: dateTimeField.controller.value.text.split(" ")[1],
        location: Location(
            address: locationField.controller.text.isEmpty
                ? Strings.homeAddress
                : locationField.controller.text),
      );

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
    bool homeStatus,
    DecoratedTextField titleField,
    DecoratedTextField locationField,
    DecoratedTextField oppositionField,
    DecoratedDateTimeField dateTimeField,
  ) {
    /// If the form inputs have been validated, update the competition.
    if (_formKey.currentState.validate()) {
      for (Map entry in _databaseEntries) {
        if (entry[Fields.id] == currentId) {
          /// This is the competition to be updated.
          entry[Fields.title] = titleField.controller.value.text;
          entry[Fields.location] = Location(
                  address: homeStatus
                      ? Strings.homeAddress
                      : locationField.controller.value.text)
              .toJson;
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

    _updateDatabase();
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
    DecoratedTextField playersField,
    DecoratedTextField oppositionField,
    int currentId,
  ) {
    /// If the form inputs have been validated, add to holes.
    if (_formKey.currentState.validate()) {
      Hole newHole = Hole(
          holeNumber:
              int.tryParse(numberField.controller.value.text).abs() ?? 0,
          holeScore: Score.fresh,
          comment: commentField.controller.text,
          lastUpdated: DateTime.now(),

          /// Note: this means that the text provided by the user which contains
          /// player names must be separated with ", " between each player.
          players: playersField.controller.value.text.split(", "),
          opposition: oppositionField.controller.value.text.split(", "));

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

  void updateHole(int index, int currentId, Hole updatedHole,
      {bool pop = false}) {
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

    _updateDatabase(pop: pop);
  }
}
