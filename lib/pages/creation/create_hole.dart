import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/creation_page.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/fields.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class CreateHole extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a hole.
  final QuerySnapshot snapshot;
  final int currentId;

  CreateHole(this.snapshot, this.currentId);

  @override
  CreateHoleState createState() => CreateHoleState();
}

class CreateHoleState extends State<CreateHole> {
  final _formKey = GlobalKey<FormState>();
  String scoreStatus = "A\\S";

  /// Fields the user must fill out to create a hole.
  DecoratedTextField numberField =
      DecoratedTextField(Fields.holeNumber, number: true);
  DecoratedTextField howthScoreField = DecoratedTextField(
    "${Fields.howth} Score",
    number: true,
  );
  DecoratedTextField oppositionScoreField = DecoratedTextField(
    "${Fields.opposition} Score",
    number: true,
  );
  DecoratedTextField playersField = DecoratedTextField(Fields.players);

  DropdownButton get _score => DropdownButton<String>(
      value: scoreStatus,
      iconEnabledColor: Palette.dark,
      iconSize: 30.0,
      style: TextStyle(color: Palette.dark, fontSize: 15.5),
      underline: Container(
        height: 0.0,
      ),
      onChanged: (String newValue) {
        setState(() {
          scoreStatus = newValue;
          howthScoreField.controller.text = scoreStatus == "A\\S" ? "-" : "";
          oppositionScoreField.controller.text =
              scoreStatus == "A\\S" ? "-" : "";
        });
      },
      items: <String>["Up", "Under", "A\\S"]
          .map<DropdownMenuItem<String>>((String value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList());

  /// See [CreateCompetitionState._form].
  Form get _form => Form(
      key: _formKey,
      child: Toolkit.getCard(
        Padding(
          child: ListView(
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 15.0),
            shrinkWrap: true,
            children: <Widget>[
              numberField,
              CreationPage.getSpecialInput("Howth is: ", _score),
              scoreStatus == "A\\S" ? Container() : howthScoreField,
              scoreStatus == "A\\S" ? Container() : oppositionScoreField,
              playersField,
              Toolkit.getFormText("Names separated by commas")
            ],
          ),
          padding: EdgeInsets.all(5.0),
        ),
      ));

  void _onPressed() {
    DataBaseInteraction.addHole(
        context,
        _formKey,
        numberField,
        howthScoreField,
        oppositionScoreField,
        scoreStatus,
        playersField,
        widget.snapshot,
        widget.currentId);
  }

  @override
  Widget build(BuildContext context) {
    return CreationPage.construct('New Hole', _onPressed, _form);
  }
}
