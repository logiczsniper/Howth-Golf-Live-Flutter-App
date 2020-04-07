import 'package:flutter/material.dart';
import 'package:howth_golf_live/style/palette.dart';

class IconButtonPair extends StatelessWidget {
  final Color iconColor;
  final Function onAdd;
  final Function onSubtract;

  const IconButtonPair(
      {this.iconColor = Palette.dark,
      @required this.onAdd,
      @required this.onSubtract});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 4.0, left: 0.5, right: 0.5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                  onTap: onAdd,
                  child: Icon(
                    Icons.add_circle,
                    color: iconColor,
                    size: 34.0,
                  )),
              GestureDetector(
                  onTap: onSubtract,
                  child: Icon(
                    Icons.remove_circle,
                    size: 31.5,
                    color: iconColor.withAlpha(245),
                  )),
            ]));
  }
}
