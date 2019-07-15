import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/static/constants.dart';

class MiddleRow extends StatelessWidget {
  final String text;
  final Icon icon;

  const MiddleRow(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        Container(
            child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.fade,
          style: Constants.cardSubTitleTextStyle.apply(fontSizeDelta: -2),
        )),
      ],
    );
  }
}
