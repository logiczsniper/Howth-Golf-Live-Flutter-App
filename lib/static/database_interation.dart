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
      DecoratedTextField locationField,
      DecoratedTextField oppositionField,
      DecoratedDateTimeField dateTimeField) {
    /// If the form inputs have been validated, add to competitions.
    if (_formKey.currentState.validate()) {
      DataBaseEntry newEntry = DataBaseEntry(
          id: _id,
          title: titleField.controller.value.text,
          location: locationField.controller.value.text,
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

    for (Map entry in dataBaseEntries) {
      if (entry[Fields.id] == currentId) {
        /// This is the competition which contains the hole to be removed.
        for (int i = 0; i < entry[Fields.holes].length; i++) {
          var hole = entry[Fields.holes][i];
          if (i != index - 1) newHoles.add(hole);
        }
        entry[Fields.holes] = newHoles;
        break;
      }
    }

    Map<String, dynamic> newData = {'data': dataBaseEntries};
    documentSnapshot.reference.updateData(newData);

    Toolkit.navigateTo(context, Toolkit.competitionsText);
  }

  /// Using the form fields, create a [Hole] and add it to the
  /// competitions holes with the [currentId].
  static void addHole(
      BuildContext context,
      GlobalKey<FormState> _formKey,
      DecoratedTextField numberField,
      DecoratedTextField scoreField,
      DecoratedTextField playersField,
      QuerySnapshot snapshot,
      int currentId) {
    /// If the form inputs have been validated, add to holes.
    if (_formKey.currentState.validate()) {
      Hole newHole = Hole(
        holeNumber: int.tryParse(numberField.controller.value.text),
        holeScore: scoreField.controller.value.text,

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

          for (var hole in entry[Fields.holes]) {
            newHoles.add(hole);
          }

          newHoles.add(newHole.toJson);

          entry[Fields.holes] = newHoles;
          break;
        }
      }

      Map<String, List> newData = {'data': dataBaseEntries};
      documentSnapshot.reference.updateData(newData);

      Navigator.of(context).pop();
    }
  }
}
