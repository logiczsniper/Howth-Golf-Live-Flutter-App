import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/fields.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class DataBaseInteraction {
  DataBaseInteraction();

  /// Remove [currentEntry] from the entries in the database.
  static void deleteCompetition(
      DataBaseEntry currentEntry, AsyncSnapshot<QuerySnapshot> snapshot) {
    DocumentSnapshot documentSnapshot = snapshot.data.documents.elementAt(0);
    List dataBaseEntries = List<dynamic>.from(documentSnapshot.data['data']);

    dataBaseEntries
        .removeWhere((rawEntry) => _isDeletionTarget(rawEntry, currentEntry));

    Map<String, dynamic> newData = {'data': dataBaseEntries};
    documentSnapshot.reference.updateData(newData);
  }

  /// Assert whether or not [rawEntry] is the entry to be deleted, [currentEntry].
  static bool _isDeletionTarget(Map rawEntry, DataBaseEntry currentEntry) {
    DataBaseEntry parsedEntry = DataBaseEntry.fromJson(rawEntry);
    return currentEntry.values == parsedEntry.values;
  }

  /// With the form fields, create a database entry, convert to json form and add to
  /// the database.
  static void addCompetition(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      GlobalKey<FormState> _formKey,
      DecoratedTextField titleField,
      bool isHome,
      DecoratedTextField locationField,
      DecoratedTextField oppositionField,
      DecoratedDateTimeField dateTimeField) {
    /// If the form inputs have been validated, add to competitions.
    if (_formKey.currentState.validate()) {
      DataBaseEntry newEntry = DataBaseEntry(
          id: _id,
          title: titleField.controller.value.text,
          location: Location(
              address: isHome
                  ? "Howth Golf Club"
                  : locationField.controller.value.text,
              isHome: isHome),
          opposition: oppositionField.controller.value.text,
          holes: [],
          score: Score.fresh,
          date: dateTimeField.controller.value.text.split(" ")[0],
          time: dateTimeField.controller.value.text.split(" ")[1]);

      DocumentSnapshot documentSnapshot = snapshot.data.documents.elementAt(0);
      List dataBaseEntries = List<dynamic>.from(documentSnapshot.data['data']);
      dataBaseEntries.add(newEntry.toJson);
      Map<String, dynamic> newData = {'data': dataBaseEntries};
      documentSnapshot.reference.updateData(newData);

      Toolkit.navigateTo(context, Toolkit.competitionsText);
    }
  }

  /// Generate the next 6-digit ID.
  static int get _id {
    String code = '';
    final Random randomIntGenerator = Random();

    for (int i = 0; i < 6; i++) {
      int nextInt = randomIntGenerator.nextInt(10);
      if (nextInt == 0 && code == '') {
        i -= 1;
        continue;
      }
      code += nextInt.toString();
    }
    return int.parse(code);
  }

  /// Remove the hole at the [index] within [DataBaseEntry.holes] at the
  /// competition with the [currentId].
  static void deleteHole(
      BuildContext context, QuerySnapshot snapshot, int index, int currentId) {
    DocumentSnapshot documentSnapshot = snapshot.documents.elementAt(0);
    List dataBaseEntries = List<dynamic>.from(documentSnapshot.data['data']);

    List newHoles = List();

    /// A list of all holes without the deleted one!
    List<Hole> parsedHoles = List();

    for (Map entry in dataBaseEntries) {
      if (entry[Fields.id] == currentId) {
        /// This is the competition which contains the hole to be removed.
        for (int i = 0; i < entry[Fields.holes].length; i++) {
          var hole = entry[Fields.holes][i];
          if (i != index - 1) {
            /// This is NOT the hole that will be removed. Add to holes.
            newHoles.add(hole);
            parsedHoles.add(Hole.fromMap(hole));
          }
        }
        entry[Fields.holes] = newHoles;

        /// Updating the score.
        Score newScore = _getScore(parsedHoles);

        entry[Fields.score] = newScore.toJson;
        break;
      }
    }

    Map<String, dynamic> newData = {'data': dataBaseEntries};
    documentSnapshot.reference.updateData(newData);
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
    DecoratedTextField scoreField,
    String scoreStatus,
    DecoratedTextField playersField,
    QuerySnapshot snapshot,
    int currentId,
  ) {
    /// If the form inputs have been validated, add to holes.
    if (_formKey.currentState.validate()) {
      Hole newHole = Hole(
        holeNumber: int.tryParse(numberField.controller.value.text),
        holeScore: scoreField.controller.text.toString() + " " + scoreStatus,

        /// Note: this means that the text provided by the user which contains
        /// player names must be separated with ", " between each player.
        players: playersField.controller.value.text.split(", "),
      );

      DocumentSnapshot documentSnapshot = snapshot.documents.elementAt(0);

      List dataBaseEntries = List<dynamic>.from(documentSnapshot.data['data']);

      for (Map entry in dataBaseEntries) {
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
          Score newScore = _getScore(parsedHoles);

          entry[Fields.score] = newScore.toJson;
          break;
        }
      }

      Map<String, List> newData = {'data': dataBaseEntries};
      documentSnapshot.reference.updateData(newData).catchError(onError);

      Navigator.of(context).pop();
    }
  }

  static void onError(var e) {
    print("Error ${e.toString()}");
  }

  /// Generate the score that corresponds to a competition with [parsedHoles].
  ///
  /// Get the updated competition score with the new hole scores,
  /// [parsedHoles], and format the score based on whether
  /// or not the scores are floats.
  static Score _getScore(List<Hole> parsedHoles) {
    /// Must also update the competition score!
    double howth = 0;
    double opposition = 0;
    for (Hole hole in parsedHoles) {
      if (hole.holeScore.contains("Up")) {
        howth++;
      } else if (hole.holeScore.contains("Under")) {
        opposition++;
      } else {
        /// Its a draw- both go up by 0.5!
        howth += 0.5;
        opposition += 0.5;
      }
    }

    /// If the scores are whole numbers, parse to int before making [Score].
    Score newScore = howth - howth.toInt() != 0
        ? Score(howth: howth.toString(), opposition: opposition.toString())
        : Score(
            howth: howth.toInt().toString(),
            opposition: opposition.toInt().toString());

    return newScore;
  }
}
