import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';

class Themes {
  /// TODO: set all of the themes here.
  static ThemeData get appTheme => ThemeData(
      primaryColor: Palette.light,
      primaryColorDark: Palette.dark,
      accentColor: Palette.maroon,
      splashColor: Palette.maroon.withAlpha(50),
      fontFamily: Strings.firaSans,
      textTheme: textTheme,
      iconTheme: iconTheme,
      inputDecorationTheme: inputDecorationTheme,
      appBarTheme: appBarTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      tabBarTheme: tabBarTheme,
      tooltipTheme: tooltipTheme);

  static TooltipThemeData tooltipTheme = TooltipThemeData(
      showDuration: Duration(seconds: 5),
      textStyle: TextStyle(color: Palette.dark),
      decoration: BoxDecoration(
          color: Palette.card.withAlpha(254),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0)));

  static TabBarTheme tabBarTheme = TabBarTheme(
      labelColor: Palette.textInMaroon, unselectedLabelColor: Palette.dark);

  static FloatingActionButtonThemeData floatingActionButtonTheme =
      FloatingActionButtonThemeData(backgroundColor: Palette.maroon);

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      contentPadding: EdgeInsets.all(16.0),
      focusedBorder: _border,
      errorBorder: _border,
      enabledBorder: _border,
      disabledBorder: _border,
      hintStyle: TextStyle(fontSize: 15, color: Palette.dark));

  static UnderlineInputBorder get _border => UnderlineInputBorder(
      borderSide: BorderSide(color: Palette.maroon, width: 1.5));

  static TextTheme get textTheme => TextTheme(

          /// Used for list tile titles.
          subhead: TextStyle(fontSize: 16, fontWeight: FontWeight.w300))
      .apply(bodyColor: Palette.dark, displayColor: Palette.dark);

  static TextStyle get formStyle =>
      TextStyle(fontSize: 14.0, color: Palette.dark);

  static TextStyle get titleStyle => TextStyle(
      fontFamily: Strings.cormorantGaramond,
      fontSize: 27.0,
      height: 0.95,
      color: Palette.dark);

  static CardTheme get cardTheme => CardTheme(color: Palette.maroon);

  static AppBarTheme get appBarTheme => AppBarTheme(
      iconTheme: iconTheme,
      actionsIconTheme: iconTheme,
      color: Palette.light,
      elevation: 0.0);

  static IconThemeData get iconTheme =>
      IconThemeData(color: Palette.dark, size: 22.0);
}
