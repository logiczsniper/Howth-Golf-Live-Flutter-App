import 'package:flutter/material.dart';

import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

/// TODO: extend functionality for deleting holes
class CustomAlertDialog extends StatelessWidget {
  final DataBaseEntry currentEntry;

  CustomAlertDialog({@required this.currentEntry})
      : assert(currentEntry != null);

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
            DataBaseInteraction.deleteCompetition(context, currentEntry);
          },
        )
      ],
    );
  }
}
