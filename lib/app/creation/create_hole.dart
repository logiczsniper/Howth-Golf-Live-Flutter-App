import 'package:flutter/material.dart';
import 'package:howth_golf_live/app/creation/creation_page.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
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
  DecoratedTextField numberField = DecoratedTextField(
    Fields.holeNumber,
    number: true,
  );
  DecoratedTextField commentField = DecoratedTextField(
    Fields.comment + Strings.notes,
    isRequired: false,
    noteText: Strings.optional,
  );
  DecoratedTextField playersField = DecoratedTextField(
    Fields.players,
    noteText: Strings.nameCommas,
  );
  DecoratedTextField oppositionField = DecoratedTextField(
    Strings.oppositionHole,
    isRequired: false,
    noteText: Strings.optional + " " + Strings.nameCommas,
  );

  /// See [CreateCompetitionState._form].
  Form get _form => Form(
      key: _formKey,
      child: UIToolkit.getCard(Padding(
        padding: EdgeInsets.all(5.0),
        child: ListView(
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 15.0),
            shrinkWrap: true,
            children: <Widget>[
              numberField,
              playersField,
              oppositionField,
              commentField,
            ]),
      )));

  void _onPressed() {
    FirebaseInteraction.of(context).addHole(
      _formKey,
      numberField,
      commentField,
      playersField,
      oppositionField,
      widget.currentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Attempt to fix bug:
    // if (widget.currentId == null) Navigator.of(context).pop();

    return construct(Strings.newHole, _onPressed, _form);
  }
}
