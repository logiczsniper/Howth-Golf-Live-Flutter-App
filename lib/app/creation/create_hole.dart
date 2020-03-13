import 'package:flutter/material.dart';
import 'package:howth_golf_live/app/creation/creation_page.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class CreateHole extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a hole.
  final int currentId;

  CreateHole(this.currentId);

  @override
  CreateHoleState createState() => CreateHoleState();
}

class CreateHoleState extends State<CreateHole> with CreationPage {
  final _formKey = GlobalKey<FormState>();
  String scoreStatus = Strings.aS;

  /// Fields the user must fill out to create a hole.
  DecoratedTextField numberField =
      DecoratedTextField(Fields.holeNumber, number: true);
  DecoratedTextField commentField =
      DecoratedTextField(Fields.comment, isRequired: false);
  DecoratedTextField howthScoreField =
      DecoratedTextField("${Fields.howth} Score", number: true);
  DecoratedTextField oppositionScoreField =
      DecoratedTextField("${Fields.opposition} Score", number: true);
  DecoratedTextField playersField = DecoratedTextField(Fields.players);

  DropdownButton<String> get _score => dropdownButton(
      scoreStatus,
      (String newValue) => setState(() {
            scoreStatus = newValue;
            howthScoreField.controller.text =
                scoreStatus == Strings.aS ? "-" : "";
            oppositionScoreField.controller.text =
                scoreStatus == Strings.aS ? "-" : "";
          }),
      <String>[Strings.up, Strings.under, Strings.aS]
          .map<DropdownMenuItem<String>>((String value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList());

  /// See [CreateCompetitionState._form].
  Form get _form => Form(
      key: _formKey,
      child: UIToolkit.getCard(Padding(
          child: ListView(
              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 15.0),
              shrinkWrap: true,
              children: <Widget>[
                numberField,
                getSpecialInput(Strings.howthIs, _score),
                scoreStatus == Strings.aS ? Container() : howthScoreField,
                scoreStatus == Strings.aS ? Container() : oppositionScoreField,
                playersField,
                UIToolkit.getFormText(Strings.nameCommas),
                commentField,
                UIToolkit.getFormText(Strings.optional)
              ]),
          padding: EdgeInsets.all(5.0))));

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
        widget.currentId);
  }

  @override
  Widget build(BuildContext context) {
    return construct('New Hole', _onPressed, _form);
  }
}
