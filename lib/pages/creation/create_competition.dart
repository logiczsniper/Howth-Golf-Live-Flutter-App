import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/creation_page.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class CreateCompetition extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a competition.
  final AsyncSnapshot<QuerySnapshot> snapshot;

  CreateCompetition(this.snapshot);

  @override
  CreateCompetitionState createState() => CreateCompetitionState();
}

class CreateCompetitionState extends State<CreateCompetition>
    with CreationPage {
  final _formKey = GlobalKey<FormState>();
  bool isHome = false;

  /// The various fields the user must fill out.
  DecoratedTextField titleField = DecoratedTextField(Fields.title);
  DecoratedTextField locationField = DecoratedTextField(Fields.location);
  DecoratedTextField oppositionField = DecoratedTextField(Fields.opposition);
  DecoratedDateTimeField dateTimeField =
      DecoratedDateTimeField("${Fields.date} & ${Fields.time}");

  /// TODO: finish implementing this method for use in both create_competition and create_hole

  DropdownButton<bool> get _home => dropdownButton(
      isHome,
      (bool newValue) => setState(() {
            isHome = newValue;
            locationField.controller.text = isHome ? "Howth Golf Club" : "";
          }),
      <bool>[true, false]
          .map<DropdownMenuItem<bool>>((bool value) => DropdownMenuItem<bool>(
              value: value, child: Text(value.toString())))
          .toList());

/*   DropdownButton get _home => DropdownButton<bool>(
      value: isHome,
      iconEnabledColor: Palette.dark,
      iconSize: 30.0,
      style: TextStyle(color: Palette.dark, fontSize: 15.5),
      underline: Container(
        height: 0.0,
      ),
      onChanged: (bool newValue) {
        setState(() {
          isHome = newValue;
          locationField.controller.text = isHome ? "Howth Golf Club" : "";
        });
      },
      items: <bool>[true, false]
          .map<DropdownMenuItem<bool>>((bool value) => DropdownMenuItem<bool>(
              value: value, child: Text(value.toString())))
          .toList()); */

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
              UIToolkit.getFormText(
                  "Try to keep title length < ~30 characters."),
              CreationPage.getSpecialInput("At home: ", _home),
              isHome ? Container() : locationField,
              oppositionField,
              dateTimeField
            ],
          ),
          padding: EdgeInsets.all(5.0))));

  void _onPressed() {
    DataBaseInteraction.addCompetition(context, widget.snapshot, _formKey,
        titleField, isHome, locationField, oppositionField, dateTimeField);
  }

  @override
  Widget build(BuildContext context) {
    return construct('New Competition', _onPressed, _form);
  }
}
