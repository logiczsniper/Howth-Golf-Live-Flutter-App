import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';

class TextStyles {
  static const TextStyle form = TextStyle(fontSize: 15.0, color: Palette.dark);

  static const TextStyle helpTitle =
      TextStyle(fontSize: 19, color: Palette.darker);

  static const TextStyle cardTitle =
      TextStyle(fontSize: 17, color: Palette.dark, fontWeight: FontWeight.w300);

  static const TextStyle cardSubTitle =
      TextStyle(fontSize: 14, color: Palette.darker);

  static const TextStyle dialog =
      TextStyle(fontSize: 17, color: Palette.maroon);

  static const TextStyle leadingChild =
      TextStyle(fontSize: 21, color: Palette.dark, fontWeight: FontWeight.w400);

  static const TextStyle noData =
      TextStyle(fontSize: 19, color: Palette.dark, fontWeight: FontWeight.w300);

  static const TextStyle scoreCard =
      TextStyle(fontSize: 14, color: Palette.dark);

  static const TextStyle description =
      TextStyle(fontSize: 14.5, color: Palette.dark);

  static const TextStyle title = TextStyle(
    fontFamily: Strings.cormorantGaramond,
    fontSize: 28.0,
    height: 0.95,
    color: Palette.darker,
  );
}
