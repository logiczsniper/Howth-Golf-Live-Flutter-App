import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/domain/firebase_interation.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CustomAlertDialog extends StatelessWidget {
  final DataBaseEntry currentEntry;
  final AsyncSnapshot<QuerySnapshot> snapshot;

  CustomAlertDialog({@required this.currentEntry, @required this.snapshot})
      : assert(currentEntry != null, snapshot != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.doubleCheck, style: UIToolkit.cardTitleTextStyle),
      content: Text(
        Strings.irreversibleAction,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            Strings.cancel,
            style: TextStyle(color: Palette.maroon),
          ),
          onPressed: Navigator.of(context).pop,
        ),
        FlatButton(
          child: Text(
            Strings.ok,
            style: TextStyle(color: Palette.maroon),
          ),
          onPressed: () {
            DataBaseInteraction.deleteCompetition(
                context, currentEntry, snapshot);
          },
        )
      ],
    );
  }
}
