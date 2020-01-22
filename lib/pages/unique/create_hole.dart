import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/fields.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class CreateHole extends StatefulWidget {
  final QuerySnapshot snapshot;
  final int currentId;

  CreateHole(this.snapshot, this.currentId);

  @override
  CreateHoleState createState() => CreateHoleState();
}

class CreateHoleState extends State<CreateHole> {
  final _formKey = GlobalKey<FormState>();
  DecoratedTextField numberField = DecoratedTextField(Fields.holeNumber);
  DecoratedTextField scoreField = DecoratedTextField(Fields.holeScore);
  DecoratedTextField playersField = DecoratedTextField(Fields.players);
  Spacer spacer = Spacer(
    flex: 1,
  );
  Spacer spacerLarge = Spacer(
    flex: 5,
  );

  Form get _form => Form(
      key: _formKey,
      child: Padding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              numberField,
              spacer,
              scoreField,
              spacer,
              playersField,
              spacerLarge
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0)));

  void _addHole() {
    /// If the form inputs have been validated, add to holes.
    if (_formKey.currentState.validate()) {
      Hole newHole = Hole(
        holeNumber: int.tryParse(numberField.controller.value.text),
        holeScore: scoreField.controller.value.text,

        /// Note: this means that the text provided by the user which contains
        /// player names must be separated with ", " between each player.
        players: playersField.controller.value.text.split(", "),
      );

      DocumentSnapshot documentSnapshot =
          widget.snapshot.documents.elementAt(0);

      List dataBaseEntries = List<dynamic>.from(documentSnapshot.data['data']);

      for (Map entry in dataBaseEntries) {
        if (entry[Fields.id] == widget.currentId) {
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

      /// TODO: shallow type competition deletion as well as all other 'var'
      Map<String, List> newData = {'data': dataBaseEntries};
      documentSnapshot.reference.updateData(newData);

      Toolkit.navigateTo(context, Toolkit.competitionsText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Hole',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: Palette.dark,
            )),
        backgroundColor: Palette.light,
        iconTheme: IconThemeData(color: Palette.dark),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'Tap to submit!',
            onPressed: _addHole,
            color: Palette.dark,
          )
        ],
        elevation: 0.0,
      ),
      body: _form,
      backgroundColor: Palette.light,
    );
  }
}
