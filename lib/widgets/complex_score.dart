import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class ComplexScore extends StatelessWidget {
  final bool isHome;
  final Score score;

  /// A small display for showing [Score]s.
  ///
  /// Must have two main capabilities: round whole numbers
  /// to int rather than having ".0" at the end, and use
  /// fractions instead of decimals.
  ComplexScore(this.isHome, this.score);

  /// Returns the main number as a string from the [score].
  ///
  /// If the main number is 0, this will display just 1 / 2 rather than
  /// 0 and 1 / 2. TODO: PR&L
  static String getMainNumber(bool condition, Score scores) {
    String score = condition ? scores.howth : scores.opposition;

    return double.tryParse(score).toInt() == 0 && Strings.isFraction(score)
        ? ""
        : double.tryParse(score).toInt().toString();
  }

  static TextSpan getFraction(bool condition, Score scores) => TextSpan(

      /// The ternary operator (and others like it) below ensure that
      /// no fraction is displayed if the [currentEntry.score] is whole.
      text: Strings.isFraction(condition ? scores.howth : scores.opposition)
          ? "1/2"
          : "",
      style: TextStyle(fontFeatures: [FontFeature.enable('frac')]));

  static RichText getMixedFraction(
          bool condition, Score scores, Score oldScores) =>
      RichText(
          key: scores.toString == oldScores.toString
              ? null
              : ValueKey(DateTime.now()),
          text: TextSpan(
            style: TextStyle(
                fontSize: 21,
                color: Palette.inMaroon,
                fontWeight: FontWeight.w400),
            children: <TextSpan>[
              /// Main number.
              TextSpan(text: getMainNumber(condition, scores)),

              /// Fraction.
              getFraction(condition, scores)
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return RichText(
      /// Conditions similar to the ternary operator below are
      /// ensuring that whichever team is home has their information
      /// on the left, and whoever is away on the right.
      text: TextSpan(style: UIToolkit.scoreCardTextStyle, children: <TextSpan>[
        /// Home team score.
        TextSpan(text: getMainNumber(isHome, score)),
        getFraction(isHome, score),

        /// Middle divider.
        TextSpan(text: " - "),

        /// Away team score.
        TextSpan(text: getMainNumber(!isHome, score)),
        getFraction(!isHome, score),
      ]),
    );
  }
}
