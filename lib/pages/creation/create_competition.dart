import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/creation_page.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/fields.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class CreateCompetition extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a competition.
  final AsyncSnapshot<QuerySnapshot> snapshot;

  CreateCompetition(this.snapshot);

  @override
  CreateCompetitionState createState() => CreateCompetitionState();
}

class CreateCompetitionState extends State<CreateCompetition> {
  final _formKey = GlobalKey<FormState>();

  /// The various fields the user must fill out.
  DecoratedTextField titleField = DecoratedTextField(Fields.title);
  DecoratedTextField locationField = DecoratedTextField(Fields.location);
  DecoratedTextField oppositionField = DecoratedTextField(Fields.opposition);
  DecoratedDateTimeField dateTimeField =
      DecoratedDateTimeField("${Fields.date} & ${Fields.time}");

  /// Gets a padded [Form] with [Spacer] widgets
  ///
  /// These are required to prevent errors when dealing with
  /// screens of smaller sizes.
  Form get _form => Form(
      key: _formKey,
      child: Toolkit.getCard(Padding(
          child: ListView(
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 15.0),
            shrinkWrap: true,
            children: <Widget>[
              titleField,
              Toolkit.getFormText("Try to stay less than 20 characters"),
              locationField,
              oppositionField,
              dateTimeField
            ],
          ),
          padding: EdgeInsets.all(5.0))));

  void _onPressed() {
    DataBaseInteraction.addCompetition(context, widget.snapshot, _formKey,
        titleField, locationField, oppositionField, dateTimeField);
  }

  @override
  Widget build(BuildContext context) {
    return CreationPage.construct('New Competition', _onPressed, _form);
  }
}
