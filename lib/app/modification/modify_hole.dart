import 'package:flutter/material.dart';

import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/app/creation/creation_page.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class ModifyHole extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a hole.
  final int index;
  final int currentId;
  final Hole currentHole;
  final String opposition;

  ModifyHole(this.currentId, this.index, this.currentHole, this.opposition);

  @override
  ModifyHoleState createState() => ModifyHoleState();
}

class ModifyHoleState extends State<ModifyHole> with CreationPage {
  final _formKey = GlobalKey<FormState>();

  /// Fields the user must fill out to create a hole.
  DecoratedTextField commentField;
  DecoratedTextField playersField;
  DecoratedTextField oppositionField;

  /// See [CreateCompetitionState._form].
  Form get _form => Form(
      key: _formKey,
      child: UIToolkit.getCard(Padding(
          child: ListView(
              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 15.0),
              shrinkWrap: true,
              children: <Widget>[
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
    Hole updatedHole = widget.currentHole.updateHole(
        newPlayers: playersField.controller.value.text.split(", "),
        newOpposition: oppositionField.controller.value.text.split(", "),
        newComment: commentField.controller.value.text);
    FirebaseInteraction.of(context)
        .updateHole(widget.index, widget.currentId, updatedHole, pop: true);
  }

  @override
  void initState() {
    super.initState();

    commentField = DecoratedTextField(
        widget.currentHole.comment.isEmpty ? Fields.comment : Strings.empty,
        initialValue: widget.currentHole.comment.isEmpty
            ? null
            : widget.currentHole.comment,
        isRequired: false);
    playersField = DecoratedTextField(Strings.empty,
        initialValue: widget.currentHole.formattedPlayers);
    oppositionField = DecoratedTextField(Strings.empty,
        initialValue: widget.currentHole.formattedOpposition(widget.opposition),
        isRequired: false);
  }

  @override
  Widget build(BuildContext context) {
    return construct(Strings.modifyHole, _onPressed, _form);
  }
}
