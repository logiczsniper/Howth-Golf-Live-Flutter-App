import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';

class ComplexScore extends StatelessWidget {
  final Score score;

  /// A small display for showing [Score]s.
  ///
  /// Must have two main capabilities: round whole numbers
  /// to int rather than having ".0" at the end, and use
  /// fractions instead of decimals.
  ComplexScore(this.score);

  /// Determines whether [score] is a string containing a fraction or whole
  /// number.
  static bool _isFraction(String score) =>
      double.tryParse(score) - double.tryParse(score).toInt() != 0;

  /// Returns the main number as a string from the [score].
  ///
  /// If the main number is 0, this will display just 1 / 2 rather than
  /// 0 and 1 / 2.
  static String _getMainNumber(bool isHowth, Score scores) {
    String score = isHowth ? scores.howth : scores.opposition;

    return double.tryParse(score).toInt() == 0 && _isFraction(score)
        ? Strings.empty
        : double.tryParse(score).toInt().toString();
  }

  static TextSpan getFraction(bool isHowth, Score scores,
          {FontWeight fontWeight}) =>
      TextSpan(

          /// The ternary operator (and others like it) below ensure that
          /// no fraction is displayed if the [currentEntry.score] is whole.
          text: _isFraction(isHowth ? scores.howth : scores.opposition)
              ? "1/2"
              : Strings.empty,
          style: TextStyle(
              fontFeatures: [FontFeature.enable('frac')],
              fontWeight: fontWeight));

  static TextSpan getMixedFraction(String scoreString) => TextSpan(
        style: TextStyle(
            fontSize: scoreString[0] == "0" ? 55 : 32,
            color: Palette.dark,
            fontWeight: FontWeight.w800),
        children: <TextSpan>[
          /// Main number.
          TextSpan(
            text: double.tryParse(scoreString).toInt() == 0 &&
                    _isFraction(scoreString)
                ? Strings.empty
                : double.tryParse(scoreString).toInt().toString(),
            style: TextStyle(fontSize: 70.0),
          ),

          /// Fraction.
          TextSpan(
            /// The ternary operator (and others like it) below ensure that
            /// no fraction is displayed if the [currentEntry.score] is whole.
            text: _isFraction(scoreString) ? "1/2" : Strings.empty,
            style: TextStyle(
              fontFeatures: [
                FontFeature.enable('frac'),
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return RichText(
      /// Conditions similar to the ternary operator below are
      /// ensuring that whichever team is home has their information
      /// on the left, and whoever is away on the right.
      text: TextSpan(style: TextStyles.scoreCard, children: <TextSpan>[
        /// Home team score.
        TextSpan(text: _getMainNumber(true, score)),
        getFraction(true, score, fontWeight: FontWeight.w600),

        /// Middle divider.
        TextSpan(text: " - "),

        /// Away team score.
        TextSpan(text: _getMainNumber(false, score)),
        getFraction(false, score, fontWeight: FontWeight.w600),
      ]),
    );
  }
}
