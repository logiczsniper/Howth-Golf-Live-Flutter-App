import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/app/creation/creation_page.dart';
import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';

class ModifyHole extends StatefulWidget {
  /// A page for the form to reside when an admin is creating a hole.
  final int index;
  final int id;

  ModifyHole(this.id, this.index);

  @override
  ModifyHoleState createState() => ModifyHoleState();
}

class ModifyHoleState extends State<ModifyHole> with CreationPage {
  Hole currentHole;
  String opposition;

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
                oppositionField,
                commentField,
              ]),
          padding: EdgeInsets.all(5.0))));

  void _onPressed() {
    Hole updatedHole = currentHole.updateHole(
        newPlayers: playersField.controller.value.text.split(", "),
        newOpposition: oppositionField.controller.value.text.split(", "),
        newComment: commentField.controller.value.text);
    FirebaseInteraction.of(context)
        .updateHole(widget.index, widget.id, updatedHole, pop: true);
  }

  @override
  void initState() {
    super.initState();

    var _firebaseModel = Provider.of<FirebaseViewModel>(context, listen: false);
    opposition = _firebaseModel.entryFromId(widget.id).opposition;
    currentHole =
        _firebaseModel.entryFromId(widget.id).holes.elementAt(widget.index);

    commentField = DecoratedTextField(
      currentHole.comment.isEmpty
          ? Fields.comment + Strings.notes
          : Strings.empty,
      initialValue: currentHole.comment.isEmpty ? null : currentHole.comment,
      isRequired: false,
      noteText: Strings.optional,
    );
    playersField = DecoratedTextField(
      Strings.empty,
      initialValue: currentHole.formattedPlayers,
      noteText: Strings.nameCommas,
    );
    oppositionField = DecoratedTextField(
      Strings.empty,
      initialValue: currentHole.formattedOpposition(opposition),
      isRequired: false,
      noteText: Strings.optional + " " + Strings.nameCommas,
    );
  }

  @override
  Widget build(BuildContext context) {
    return construct(Strings.modifyHole, _onPressed, _form);
  }
}
