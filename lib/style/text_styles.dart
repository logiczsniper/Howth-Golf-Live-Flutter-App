import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';

class TextStyles {
  static const TextStyle form = TextStyle(fontSize: 14.0, color: Palette.dark);

  static const TextStyle title = TextStyle(
      fontFamily: Strings.cormorantGaramond,
      fontSize: 27.0,
      height: 0.95,
      color: Palette.darker);

  static const TextStyle helpTitle =
      TextStyle(fontSize: 18, color: Palette.darker);

  static const TextStyle cardTitle =
      TextStyle(fontSize: 16, color: Palette.dark, fontWeight: FontWeight.w300);

  static const TextStyle cardSubTitle =
      TextStyle(fontSize: 13, color: Palette.dark);

  static const TextStyle hint = TextStyle(fontSize: 15, color: Palette.dark);

  static const TextStyle dialog =
      TextStyle(fontSize: 16, color: Palette.maroon);

  static const TextStyle leadingChild =
      TextStyle(fontSize: 20, color: Palette.dark, fontWeight: FontWeight.w400);

  static const TextStyle noData =
      TextStyle(fontSize: 18, color: Palette.dark, fontWeight: FontWeight.w300);

  static const TextStyle scoreCard =
      TextStyle(fontSize: 13, color: Palette.dark);

  static const TextStyle description =
      TextStyle(fontSize: 13.5, color: Palette.dark);
}
