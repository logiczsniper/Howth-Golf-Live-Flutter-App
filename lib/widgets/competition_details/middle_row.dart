import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/style/text_styles.dart';

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
          Flexible(
              child: Text(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.cardSubTitle.apply(fontSizeDelta: -2),
          )),
        ],
      );
}
