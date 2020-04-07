import 'package:flutter/material.dart';
import 'package:howth_golf_live/app/creation/creation_page.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class CreateCompetition extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a competition.

  CreateCompetition();

  @override
  CreateCompetitionState createState() => CreateCompetitionState();
}

class CreateCompetitionState extends State<CreateCompetition>
    with CreationPage {
  final _formKey = GlobalKey<FormState>();
  String isHome = Strings.home;

  /// The various fields the user must fill out.
  DecoratedTextField titleField = DecoratedTextField(Strings.competitionName);
  DecoratedTextField locationField = DecoratedTextField(Fields.location);
  DecoratedTextField oppositionField = DecoratedTextField(Fields.opposition);
  DecoratedDateTimeField dateTimeField =
      DecoratedDateTimeField("${Fields.date} & ${Fields.time}");

  DropdownButton<String> get _home => dropdownButton(
      isHome,
      (String newValue) => setState(() {
            isHome = newValue;
            locationField.controller.text =
                isHome == Strings.home ? Strings.homeAddress : Strings.empty;
          }),
      <String>[Strings.home, Strings.away]
          .map<DropdownMenuItem<String>>((String value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList());

  /// Gets a padded [Form] with [Spacer] widgets
  ///
  /// These are required to prevent errors when dealing with
  /// screens of smaller sizes.
  Form get _form => Form(
      key: _formKey,
      child: UIToolkit.getCard(Padding(
          child: ListView(
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 15.0),
            shrinkWrap: true,
            children: <Widget>[
              titleField,
              UIToolkit.getFormText(Strings.titleLengthNote),
              getSpecialInput(Strings.empty, _home),
              isHome == Strings.home ? Container() : locationField,
              oppositionField,
              dateTimeField
            ],
          ),
          padding: EdgeInsets.all(5.0))));

  void _onPressed() {
    FirebaseInteraction.of(context).addCompetition(
        _formKey, titleField, locationField, oppositionField, dateTimeField);
  }

  @override
  Widget build(BuildContext context) {
    return construct(Strings.newCompetition, _onPressed, _form);
  }
}
