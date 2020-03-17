import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';

class TextStyles {
  static const TextStyle formStyle =
      TextStyle(fontSize: 14.0, color: Palette.dark);

  static const TextStyle dialogStyle =
      TextStyle(fontSize: 16, color: Palette.maroon);

  static const TextStyle titleStyle = TextStyle(
      fontFamily: Strings.cormorantGaramond,
      fontSize: 27.0,
      height: 0.95,
      color: Color.fromARGB(255, 85, 85, 85));
  static const TextStyle cardTitleTextStyle =
      TextStyle(fontSize: 16, color: Palette.dark, fontWeight: FontWeight.w300);

  static const TextStyle cardSubTitleTextStyle =
      TextStyle(fontSize: 13, color: Palette.dark);

  static const TextStyle hintTextStyle =
      TextStyle(fontSize: 15, color: Palette.dark);

  static const TextStyle dialogTextStyle =
      TextStyle(fontSize: 16, color: Palette.maroon);

  static const TextStyle leadingChildTextStyle =
      TextStyle(fontSize: 20, color: Palette.dark, fontWeight: FontWeight.w400);

  static const TextStyle noDataTextStyle =
      TextStyle(fontSize: 18, color: Palette.dark, fontWeight: FontWeight.w300);
  static const TextStyle scoreCardTextStyle = TextStyle(
    fontSize: 13,
    color: Palette.dark,
  );
}
