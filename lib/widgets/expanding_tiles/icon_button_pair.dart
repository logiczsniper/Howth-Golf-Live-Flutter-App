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
        padding: EdgeInsets.all(4.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                  // padding: EdgeInsets.zero,
                  // padding: EdgeInsets.only(top: 8.0),

                  onTap: onAdd,
                  child: Icon(
                    Icons.add_circle,
                    color: iconColor,
                    size: 35.0,
                  )),
              GestureDetector(
                  // padding: EdgeInsets.only(top: 3.0),
                  // padding: EdgeInsets.zero,

                  onTap: onSubtract,
                  child: Icon(
                    Icons.remove_circle,
                    size: 23.0,
                    color: iconColor,
                  )),
            ]));
  }
}
