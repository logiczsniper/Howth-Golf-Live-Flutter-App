import 'package:flutter/material.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';

class CustomAlertDialog extends StatelessWidget {
  final Function deletionMethod;

  final int index;
  final int id;

  CustomAlertDialog(this.deletionMethod, {this.index, this.id})
      : assert(deletionMethod is void Function(int) && id != null ||
            deletionMethod is void Function(int, int) &&
                index != null &&
                id != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.doubleCheck, style: TextStyles.cardTitle),
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
            index == null ? deletionMethod(id) : deletionMethod(index, id);
          },
        )
      ],
    );
  }
}
