import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class ComplexCard extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final dynamic iconButton;

  ComplexCard({this.child, this.onTap, this.iconButton});

  InkWell _getInkWell() {
    return InkWell(
      highlightColor: Colors.transparent,
      radius: 500.0,
      borderRadius: BorderRadius.circular(10.0),
      splashColor: Toolkit.accentAppColor.withAlpha(50),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topWidget = iconButton == null ? Container() : iconButton;
    return Stack(children: <Widget>[
      Toolkit.getCard(child),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.5, horizontal: 9.5),
                  child: _getInkWell()))),
      Align(
          alignment: Alignment.centerRight,
          child: Padding(padding: EdgeInsets.all(23.5), child: topWidget))
    ]);
  }
}
