import 'package:flutter/material.dart';

import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class ComplexCard extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final dynamic iconButton;

  /// A [Card] with a custom [InkWell] and uses a [Stack] to enable
  /// a button to exist on top of the already tap-able card.
  ComplexCard({this.child, this.onTap, this.iconButton});

  /// A maroon coloured [InkWell] that stays within the bounds of the card.
  InkWell get _inkWell => InkWell(
        highlightColor: Colors.transparent,
        radius: 500.0,
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Palette.maroon.withAlpha(60),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    /// The tap-able widget to lie on top of the card, positioned
    /// where a standard ending icon would be.
    final Widget topWidget = iconButton ?? Container();
    return Stack(children: <Widget>[
      UIToolkit.getCard(child),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.5, horizontal: 12.0),
                  child: _inkWell))),
      Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: EdgeInsets.fromLTRB(2.0, 10.0, 17.0, 0.0),
              child: topWidget))
    ]);
  }
}
