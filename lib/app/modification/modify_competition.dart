import 'package:flutter/material.dart';

import 'package:howth_golf_live/app/creation/creation_page.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
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
  String isHome;

  /// The various fields the user must fill out.
  DecoratedTextField titleField;
  DecoratedTextField locationField;
  DecoratedTextField oppositionField;
  DecoratedDateTimeField dateTimeField;

  DropdownButton<String> get _home => dropdownButton(
      isHome,
      (String newValue) => setState(() {
            isHome = newValue;
            locationField.controller.text =
                newValue == Strings.home ? Strings.homeAddress : Strings.empty;
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
    FirebaseInteraction.of(context).updateCompetition(
        _formKey,
        widget.currentEntry.id,
        isHome == Strings.home,
        titleField,
        locationField,
        oppositionField,
        dateTimeField);
  }

  @override
  void initState() {
    super.initState();

    isHome = widget.currentEntry.location.isHome ? Strings.home : Strings.away;
    titleField = DecoratedTextField(Strings.empty,
        initialValue: widget.currentEntry.title);
    locationField = DecoratedTextField(
        Strings.location.substring(0, Strings.location.length - 1),
        initialValue: widget.currentEntry.location.address);
    oppositionField = DecoratedTextField(Strings.empty,
        initialValue: widget.currentEntry.opposition);
    dateTimeField = DecoratedDateTimeField(Strings.empty,
        initialValue:
            "${widget.currentEntry.date} ${widget.currentEntry.time}");
  }

  @override
  Widget build(BuildContext context) {
    return construct(Strings.modifyCompetition, _onPressed, _form);
  }
}
