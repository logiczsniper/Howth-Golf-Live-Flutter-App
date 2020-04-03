import 'package:flutter/material.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';

class Themes {
  static ThemeData get appTheme => ThemeData(
      colorScheme: colorScheme,
      primaryColor: Palette.light,
      primaryColorDark: Palette.dark,
      accentColor: Palette.maroon,
      splashColor: Palette.maroon.withAlpha(50),
      disabledColor: Palette.maroon,
      textSelectionHandleColor: Palette.maroon,
      textSelectionColor: Palette.maroon,
      scaffoldBackgroundColor: Palette.light,
      fontFamily: Strings.firaSans,
      textTheme: textTheme,
      iconTheme: iconTheme,
      inputDecorationTheme: inputDecorationTheme,
      appBarTheme: appBarTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      tabBarTheme: tabBarTheme,
      tooltipTheme: tooltipTheme,
      cardTheme: cardTheme,
      pageTransitionsTheme: pageTransitionsTheme,
      dialogTheme: dialogTheme,
      buttonTheme: buttonTheme,
      snackBarTheme: snackBarThemeData,
      dividerTheme: dividerTheme);

  static DividerThemeData dividerTheme = DividerThemeData(
      color: Palette.divider,
      indent: 60.0,
      endIndent: 60.0,
      thickness: 1.5,
      space: 27.5);

  static SnackBarThemeData snackBarThemeData = SnackBarThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(13),
      )),
      backgroundColor: Palette.card.withAlpha(253),
      contentTextStyle: TextStyle(color: Palette.dark));

  static ButtonThemeData buttonTheme = ButtonThemeData(
      splashColor: Palette.maroon.withAlpha(60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      textTheme: ButtonTextTheme.accent);

  static DialogTheme dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
    elevation: 0.1,
    titleTextStyle: TextStyle(color: Palette.dark, fontSize: 14.0),
    contentTextStyle: TextStyle(color: Palette.dark, fontSize: 13.0),
  );

  static PageTransitionsTheme pageTransitionsTheme =
      PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
  });

  static TooltipThemeData tooltipTheme = TooltipThemeData(
      showDuration: Duration(seconds: 5),
      textStyle: TextStyle(color: Palette.dark),
      decoration: BoxDecoration(
          color: Palette.card.withAlpha(254),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(13.0)));

  static TabBarTheme tabBarTheme = TabBarTheme(
      labelColor: Color.fromARGB(250, 247, 247, 247),
      unselectedLabelColor: Palette.dark);

  static FloatingActionButtonThemeData floatingActionButtonTheme =
      FloatingActionButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          backgroundColor: Palette.maroon,
          elevation: 0.25);

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 14.0),
      focusedBorder: _border,
      errorBorder: _border,
      focusedErrorBorder: _border,
      enabledBorder: _border,
      disabledBorder: _border,
      hintStyle: TextStyle(fontSize: 16, color: Palette.dark),
      errorStyle: TextStyle(fontSize: 13, color: Palette.maroon));

  static UnderlineInputBorder get _border => UnderlineInputBorder(
      borderSide: BorderSide(color: Palette.maroon, width: 1.5));

  static ColorScheme get colorScheme => ColorScheme(
      primary: Palette.dark,
      primaryVariant: Color.fromARGB(255, 250, 250, 250),
      secondary: Palette.maroon,
      secondaryVariant: Color.fromARGB(255, 120, 0, 0),
      surface: Palette.card,
      background: Palette.light,
      error: Palette.maroon,
      onPrimary: Palette.dark,
      onSecondary: Palette.inMaroon,
      onSurface: Palette.dark,
      onBackground: Palette.dark,
      onError: Palette.inMaroon,
      brightness: Brightness.light);

  static TextTheme get textTheme => TextTheme(
          button: TextStyles.dialog,

          /// Used for list tile titles.
          subhead: TextStyle(fontSize: 17, fontWeight: FontWeight.w300))
      .apply(bodyColor: Palette.dark, displayColor: Palette.dark);

  static TextTheme get titleTheme => TextTheme(title: TextStyles.title);

  static CardTheme get cardTheme => CardTheme(
        color: Palette.card,
        elevation: 0.01,
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      );

  static AppBarTheme get appBarTheme => AppBarTheme(
      iconTheme: iconTheme,
      actionsIconTheme: iconTheme,
      textTheme: titleTheme,
      color: Palette.light,
      elevation: 0.0);

  static IconThemeData get iconTheme =>
      IconThemeData(color: Palette.dark, size: 22.0);
}
