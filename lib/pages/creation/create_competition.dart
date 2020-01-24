import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/creation_page.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/fields.dart';
import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class CreateCompetition extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  CreateCompetition(this.snapshot);

  @override
  CreateCompetitionState createState() => CreateCompetitionState();
}

class CreateCompetitionState extends State<CreateCompetition> {
  final _formKey = GlobalKey<FormState>();
  DecoratedTextField titleField = DecoratedTextField(Fields.title);
  DecoratedTextField locationField = DecoratedTextField(Fields.location);
  DecoratedTextField oppositionField = DecoratedTextField(Fields.opposition);
  DecoratedDateTimeField dateTimeField =
      DecoratedDateTimeField("${Fields.date} & ${Fields.time}");

  Spacer spacerLarge = Spacer(
    flex: 6,
  );

  Form get _form => Form(
      key: _formKey,
      child: Padding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              titleField,
              CreationPage.spacer,
              locationField,
              CreationPage.spacer,
              oppositionField,
              CreationPage.spacer,
              dateTimeField,
              spacerLarge
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0)));

  void _onPressed() {
    DataBaseInteraction.addCompetition(context, widget.snapshot, _formKey,
        titleField, locationField, oppositionField, dateTimeField);
  }

  @override
  Widget build(BuildContext context) {
    return CreationPage.construct('New Competition', _onPressed, _form);
  }
}
