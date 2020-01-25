import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';

class Themes {
  static ThemeData get appTheme => ThemeData(
      primaryColor: Palette.light,
      primaryColorDark: Palette.dark,
      accentColor: Palette.maroon,
      textTheme: textTheme,
      iconTheme: iconTheme);

  static TextTheme get textTheme => TextTheme().apply(bodyColor: Palette.dark);

  static IconThemeData get iconTheme =>
      IconThemeData(color: Palette.maroon, size: 22.0);

  static TextStyle get textStyle =>
      TextStyle(color: Palette.dark, fontSize: 40.0);
}
