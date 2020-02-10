import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class SideFlexible extends StatelessWidget {
  final String score;

  /// Shows the overall competition score, [text] for a specific competition.
  const SideFlexible(this.score);

  Widget get _text => RichText(
          text: TextSpan(
              text: double.tryParse(score).toInt() == 0 &&
                      Toolkit.isFraction(score)
                  ? ""
                  : double.tryParse(score).toInt().toString(),
              style: TextStyle(
                  fontSize: 21,
                  color: Palette.buttonText,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
            TextSpan(
                text: Toolkit.isFraction(score) ? "1/2" : "",
                style: TextStyle(
                    fontSize: 21,
                    color: Palette.buttonText,
                    fontFeatures: [FontFeature.enable('frac')]))
          ]));

  /// The maroon decoration around the [text].
  Decoration get _decoration => ShapeDecoration(
      color: Palette.maroon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));

  @override
  Widget build(BuildContext context) => Flexible(
      flex: 1,
      child: Column(children: <Widget>[
        Container(
            padding: EdgeInsets.all(12.0),
            child: _text,
            decoration: _decoration)
      ]));
}
