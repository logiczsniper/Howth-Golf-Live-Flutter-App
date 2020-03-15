import 'package:flutter/material.dart';

import 'package:howth_golf_live/app/creation/creation_page.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class ModifyCompetition extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a competition.
  final DatabaseEntry currentEntry;

  ModifyCompetition(this.currentEntry);

  @override
  ModifyCompetitionState createState() => ModifyCompetitionState();
}

class ModifyCompetitionState extends State<ModifyCompetition>
    with CreationPage {
  final _formKey = GlobalKey<FormState>();
  bool isHome;

  /// The various fields the user must fill out.
  DecoratedTextField titleField;
  DecoratedTextField locationField;
  DecoratedTextField oppositionField;
  DecoratedDateTimeField dateTimeField;

  DropdownButton<bool> get _home => dropdownButton(
      isHome,
      (bool newValue) => setState(() {
            isHome = newValue;
            locationField.controller.text = isHome ? Strings.homeAddress : "";
          }),
      <bool>[true, false]
          .map<DropdownMenuItem<bool>>((bool value) => DropdownMenuItem<bool>(
              value: value, child: Text(value.toString())))
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
              getSpecialInput(Strings.atHome, _home),
              isHome ? Container() : locationField,
              oppositionField,
              dateTimeField
            ],
          ),
          padding: EdgeInsets.all(5.0))));

  void _onPressed() {
    FirebaseInteration(context).updateCompetition(
        _formKey,
        widget.currentEntry.id,
        isHome,
        titleField,
        locationField,
        oppositionField,
        dateTimeField);
  }

  @override
  void initState() {
    super.initState();

    isHome = widget.currentEntry.location.isHome;
    titleField =
        DecoratedTextField("", initialValue: widget.currentEntry.title);
    locationField = DecoratedTextField("",
        initialValue: widget.currentEntry.location.address);
    oppositionField =
        DecoratedTextField("", initialValue: widget.currentEntry.opposition);
    dateTimeField = DecoratedDateTimeField("",
        initialValue:
            "${widget.currentEntry.date} ${widget.currentEntry.time}");
  }

  @override
  Widget build(BuildContext context) {
    return construct(Strings.modifyCompetition, _onPressed, _form);
  }
}
