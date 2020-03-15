import 'package:flutter/material.dart';

import 'package:howth_golf_live/app/creation/creation_page.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/services/utils.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class ModifyHole extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a hole.
  final int index;
  final int currentId;
  final Hole currentHole;

  ModifyHole(this.currentId, this.index, this.currentHole);

  @override
  ModifyHoleState createState() => ModifyHoleState();
}

class ModifyHoleState extends State<ModifyHole> with CreationPage {
  final _formKey = GlobalKey<FormState>();

  /// Fields the user must fill out to create a hole.
  DecoratedTextField commentField;
  DecoratedTextField playersField;

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
                commentField,
                UIToolkit.getFormText(Strings.optional)
              ]),
          padding: EdgeInsets.all(5.0))));

  void _onPressed() {
    Hole updatedHole = widget.currentHole.updateHole(
        newPlayers: playersField.controller.value.text.split(", "),
        newComment: commentField.controller.value.text);
    FirebaseInteration(context)
        .updateHole(widget.index, widget.currentId, updatedHole);
  }

  @override
  void initState() {
    super.initState();

    /// TODO: change this to the default text, not the hint text! same on modify competition!!
    commentField =
        DecoratedTextField(widget.currentHole.comment, isRequired: false);
    playersField =
        DecoratedTextField(Utils.formatPlayers(widget.currentHole.players));
  }

  @override
  Widget build(BuildContext context) {
    return construct(Strings.modifyHole, _onPressed, _form);
  }
}
