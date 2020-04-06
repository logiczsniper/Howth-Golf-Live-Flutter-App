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

  /// Fields the user must fill out to create a hole.
  DecoratedTextField numberField =
      DecoratedTextField(Fields.holeNumber, number: true);
  DecoratedTextField commentField =
      DecoratedTextField(Fields.comment, isRequired: false);
  DecoratedTextField playersField = DecoratedTextField(Fields.players);
  DecoratedTextField oppositionField =
      DecoratedTextField(Fields.opposition, isRequired: false);

  /// See [CreateCompetitionState._form].
  Form get _form => Form(
      key: _formKey,
      child: UIToolkit.getCard(Padding(
          child: ListView(
              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 15.0),
              shrinkWrap: true,
              children: <Widget>[
                numberField,
                playersField,
                UIToolkit.getFormText(Strings.nameCommas),
                oppositionField,
                UIToolkit.getFormText(
                    Strings.optional + " " + Strings.nameCommas),
                commentField,
                UIToolkit.getFormText(Strings.optional)
              ]),
          padding: EdgeInsets.all(5.0))));

  void _onPressed() {
    FirebaseInteration.of(context).addHole(_formKey, numberField, commentField,
        playersField, oppositionField, widget.currentId);
  }

  @override
  Widget build(BuildContext context) {
    return construct(Strings.newHole, _onPressed, _form);
  }
}
