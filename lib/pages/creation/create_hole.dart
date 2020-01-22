import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/creation_page.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/fields.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class CreateHole extends StatefulWidget {
  final QuerySnapshot snapshot;
  final int currentId;

  CreateHole(this.snapshot, this.currentId);

  @override
  CreateHoleState createState() => CreateHoleState();
}

class CreateHoleState extends State<CreateHole> {
  final _formKey = GlobalKey<FormState>();
  DecoratedTextField numberField = DecoratedTextField(Fields.holeNumber);
  DecoratedTextField scoreField = DecoratedTextField(Fields.holeScore);
  DecoratedTextField playersField = DecoratedTextField(Fields.players);
  Spacer spacer = Spacer(
    flex: 1,
  );
  Spacer spacerLarge = Spacer(
    flex: 5,
  );

  Form get _form => Form(
      key: _formKey,
      child: Padding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              numberField,
              spacer,
              scoreField,
              spacer,
              playersField,
              spacerLarge
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0)));

  void _onPressed() {
    DataBaseInteraction.addHole(context, _formKey, numberField, scoreField,
        playersField, widget.snapshot, widget.currentId);
  }

  @override
  Widget build(BuildContext context) {
    return CreationPage.construct('New Hole', _onPressed, _form);
  }
}
