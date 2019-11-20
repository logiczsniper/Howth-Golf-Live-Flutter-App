import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/static/constants.dart';

class SideFlexible extends StatelessWidget {
  final String text;

  const SideFlexible(this.text);

  Text _getText() {
    return Text(text,
        overflow: TextOverflow.fade,
        maxLines: 1,
        style: TextStyle(
            fontSize: 21,
            color: Constants.primaryAppColorDark,
            fontWeight: FontWeight.w400));
  }

  Decoration _getDecoration() {
    return ShapeDecoration(
                    color: Constants.accentAppColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0));
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(12.0),
                child: _getText(),
                decoration: _getDecoration()
        )]));
  }
}
