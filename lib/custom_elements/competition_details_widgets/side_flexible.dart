import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/static/constants.dart';

class SideFlexible extends StatelessWidget {
  final String text;

  const SideFlexible(this.text);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(12.0),
                child: Text(text,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 21,
                        color: Constants.primaryAppColorDark,
                        fontWeight: FontWeight.w400)),
                decoration: ShapeDecoration(
                    color: Constants.accentAppColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)))),
          ],
        ));
  }
}
