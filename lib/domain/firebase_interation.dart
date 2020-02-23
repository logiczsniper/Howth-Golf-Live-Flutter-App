import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/presentation/utils.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class DataBaseInteraction {
  DataBaseInteraction();

  static Stream<QuerySnapshot> get stream => Firestore.instance
      .collection(Strings.competitionsText.toLowerCase())
      .snapshots();

  static Future<int> get adminCode {
    Future<int> adminCode =
        Future<int>.value(stream.first.then((QuerySnapshot snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.documents.elementAt(0);
      int adminCode = documentSnapshot.data['admin_code'];
      return adminCode;
    }));

    return adminCode;
  }

  /// Fetch and parse (to [DataBaseEntry] objects) all of the competitions
  /// from [Firestore]. The [document] contains the data which, in turn,
  /// contains the [rawElements] in the database.
  static List<DataBaseEntry> getDataBaseEntries(DocumentSnapshot document) {
    /// The [entries] in my [Firestore] instance, at index 1- the admin code is at 0.
    List<dynamic> rawElements = document.data.entries.toList()[1].value;

    /// Those same [entries] but in a structured format- [DataBaseEntry].
    List<DataBaseEntry> parsedElements = rawElements
        .map((dynamic element) => DataBaseEntry.fromMap(element))
        .toList();

    return parsedElements;
  }

  /// Remove [currentEntry] from the entries in the database.
  static void deleteCompetition(BuildContext context,
      DataBaseEntry currentEntry, AsyncSnapshot<QuerySnapshot> snapshot) {
    DocumentSnapshot documentSnapshot = snapshot.data.documents.elementAt(0);
    List dataBaseEntries = List<dynamic>.from(documentSnapshot.data['data']);

    dataBaseEntries
        .removeWhere((rawEntry) => currentEntry.isDeletionTarget(rawEntry));

    Map<String, dynamic> newData = {'data': dataBaseEntries};
    documentSnapshot.reference
        .updateData(newData)
        .catchError(onError)
        .whenComplete(Navigator.of(context).pop);
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
          id: Utils.id,
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

      Routes.navigateTo(context, Strings.competitionsText);
    }
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

    Map<String, dynamic> newData = {'data': dataBaseEntries};
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
    AsyncSnapshot<QuerySnapshot> snapshot,
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

      DocumentSnapshot documentSnapshot = snapshot.data.documents.elementAt(0);

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
          Score newScore = Score.fromParsedHoles(parsedHoles);

          entry[Fields.score] = newScore.toJson;
          break;
        }
      }

      Map<String, List> newData = {'data': dataBaseEntries};
      documentSnapshot.reference
          .updateData(newData)
          .catchError(onError)
          .whenComplete(Navigator.of(context).pop);
    }
  }

  static void onError(var e) {
    print("Error ${e.toString()}");
  }

  static void updateHole(BuildContext context, QuerySnapshot snapshot,
      int index, int currentId, Hole updatedHole) {
    DocumentSnapshot documentSnapshot = snapshot.documents.elementAt(0);
    List dataBaseEntries = List<dynamic>.from(documentSnapshot.data['data']);

    List newHoles = List();

    /// A list of all holes with the updated one!
    List<Hole> parsedHoles = List();

    for (Map entry in dataBaseEntries) {
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

    Map<String, dynamic> newData = {'data': dataBaseEntries};
    documentSnapshot.reference.updateData(newData);
  }
}
