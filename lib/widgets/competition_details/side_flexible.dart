import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';

class SideFlexible extends StatelessWidget {
  final String score;

  /// Shows the overall competition score, [text] for a specific competition.
  const SideFlexible(this.score);

  /// Displays the text of the score.
  ///
  /// If the value is not whole and not equal to 0, it
  /// will display a fraction. Else, will display the whole number.
  Widget get _text => RichText(

          /// Primary text value.
          text: TextSpan(
              text: double.tryParse(score).toInt() == 0 &&
                      Strings.isFraction(score)
                  ? ""
                  : double.tryParse(score).toInt().toString(),
              style: TextStyle(
                  fontSize: 21,
                  color: Palette.inMaroon,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
            /// Secondary text value (fractional).
            TextSpan(
                text: Strings.isFraction(score) ? "1/2" : "",
                style: TextStyle(
                    fontSize: 21,
                    color: Palette.inMaroon,
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
            child:
                AnimatedSwitcher(child: _text, duration: Duration(seconds: 2)),
            decoration: _decoration)
      ]));
}
