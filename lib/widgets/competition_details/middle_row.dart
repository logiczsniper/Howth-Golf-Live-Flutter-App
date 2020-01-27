import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class MiddleRow extends StatelessWidget {
  final String text;
  final Icon icon;

  /// Shows an icon, [icon] followed by a value of the competition, [text].
  const MiddleRow(this.text, this.icon);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Container(
              child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: Toolkit.cardSubTitleTextStyle.apply(fontSizeDelta: -2),
          )),
        ],
      );
}
