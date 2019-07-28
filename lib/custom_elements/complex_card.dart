import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class ComplexCard extends StatelessWidget {
  final Widget child;
  final Function onTap;

  ComplexCard(this.child, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 1.85,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
              decoration: Constants.roundedRectBoxDecoration, child: child)),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.5, horizontal: 9.5),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    radius: 500.0,
                    borderRadius: BorderRadius.circular(10.0),
                    splashColor: Constants.accentAppColor.withAlpha(50),
                    onTap: onTap,
                  ))))
    ]);
  }
}
