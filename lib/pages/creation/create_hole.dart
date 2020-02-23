import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/creation_page.dart';
import 'package:howth_golf_live/domain/firebase_interation.dart';
import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class CreateHole extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a hole.
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int currentId;

  CreateHole(this.snapshot, this.currentId);

  @override
  CreateHoleState createState() => CreateHoleState();
}

class CreateHoleState extends State<CreateHole> with CreationPage {
  final _formKey = GlobalKey<FormState>();
  String scoreStatus = "A\\S";

  /// Fields the user must fill out to create a hole.
  DecoratedTextField numberField =
      DecoratedTextField(Fields.holeNumber, number: true);
  DecoratedTextField commentField = DecoratedTextField(
    Fields.comment,
    isRequired: false,
  );
  DecoratedTextField howthScoreField = DecoratedTextField(
    "${Fields.howth} Score",
    number: true,
  );
  DecoratedTextField oppositionScoreField = DecoratedTextField(
    "${Fields.opposition} Score",
    number: true,
  );
  DecoratedTextField playersField = DecoratedTextField(Fields.players);

  DropdownButton<String> get _score => dropdownButton(
      scoreStatus,
      (String newValue) => setState(() {
            scoreStatus = newValue;
            howthScoreField.controller.text = scoreStatus == "A\\S" ? "-" : "";
            oppositionScoreField.controller.text =
                scoreStatus == "A\\S" ? "-" : "";
          }),
      <String>["Up", "Under", "A\\S"]
          .map<DropdownMenuItem<String>>((String value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList());

  /// See [CreateCompetitionState._form].
  Form get _form => Form(
      key: _formKey,
      child: UIToolkit.getCard(
        Padding(
          child: ListView(
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 15.0),
            shrinkWrap: true,
            children: <Widget>[
              numberField,
              getSpecialInput("Howth is: ", _score),
              scoreStatus == "A\\S" ? Container() : howthScoreField,
              scoreStatus == "A\\S" ? Container() : oppositionScoreField,
              playersField,
              UIToolkit.getFormText("Names separated by commas."),
              commentField,
              UIToolkit.getFormText("This is completely optional.")
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
        commentField,
        howthScoreField,
        oppositionScoreField,
        scoreStatus,
        playersField,
        widget.snapshot,
        widget.currentId);
  }

  @override
  Widget build(BuildContext context) {
    return construct('New Hole', _onPressed, _form);
  }
}
