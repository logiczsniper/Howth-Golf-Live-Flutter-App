import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/creation_page.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/fields.dart';
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

  /// Fields the user must fill out to create a hole.
  DecoratedTextField numberField = DecoratedTextField(Fields.holeNumber);
  DecoratedTextField scoreField = DecoratedTextField(Fields.holeScore);
  DecoratedTextField playersField = DecoratedTextField(Fields.players);

  Spacer spacerLarge = Spacer(
    flex: 7,
  );

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
              Toolkit.getFormText("Any Number"),
              scoreField,
              Toolkit.getFormText(
                  "Number followed by 'up' or 'under', E.g. 3 up"),
              playersField,
              Toolkit.getFormText("Names separated by commas")
            ],
          ),
          padding: EdgeInsets.all(5.0),
        ),
      ));

  void _onPressed() {
    DataBaseInteraction.addHole(context, _formKey, numberField, scoreField,
        playersField, widget.snapshot, widget.currentId);
  }

  @override
  Widget build(BuildContext context) {
    return CreationPage.construct('New Hole', _onPressed, _form);
  }
}
