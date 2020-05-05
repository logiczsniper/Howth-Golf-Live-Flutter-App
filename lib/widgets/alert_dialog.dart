import 'package:flutter/material.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';

typedef CompetitionDeleter = void Function(int);
typedef HoleDeleter = void Function(int, int);

/// [AlertDialog] with my own style and [deletionMethod] which
/// is called when the OK button is pressed.
///
/// This method will either be deleting a [DatabaseEntry] or a
/// [Hole] from an entry.
///
/// To delete a competition, we only need the [id].
/// To delete a hole, we need both the [id] and the [index].
class CustomAlertDialog extends StatelessWidget {
  final Function deletionMethod;

  final int index;
  final int id;

  CustomAlertDialog(this.deletionMethod, {this.index, this.id})
      : assert(
          deletionMethod is CompetitionDeleter && id != null ||
              deletionMethod is HoleDeleter && index != null && id != null,
        );

  /// Returns the colored [Text].
  Text _getText(String text) => Text(
        text,
        style: TextStyle(color: Palette.maroon),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(Strings.irreversibleAction),
      title: Text(
        Strings.doubleCheck,
        style: TextStyles.cardTitle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: _getText(Strings.cancel),
          onPressed: Navigator.of(context).pop,
        ),
        FlatButton(
          child: _getText(Strings.ok),
          onPressed: () {
            deletionMethod is CompetitionDeleter
                ? deletionMethod(id)
                : deletionMethod(index, id);
          },
        )
      ],
    );
  }
}
