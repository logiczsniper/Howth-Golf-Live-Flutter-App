import 'package:flutter/material.dart';

class Constants {
  static String get appName => "Howth Golf Live";

  static const String currentText = "Current";
  static const String archivedText = "Archived";
  static const String favouritesText = "Favourites";

  static const String competitionsText = "Competitions";
  static const String resultsText = "Results";
  static const String clubLinksText = "Club Links";
  static const String appHelpText = "App Help";

  static const Color primaryAppColor = Colors.white;
  static const Color primaryAppColorDark = Color.fromARGB(255, 187, 187, 187);
  static const Color accentAppColor = Color.fromARGB(255, 153, 0, 0);
  static const Color secondaryHeaderAppColor = Color.fromARGB(255, 57, 57, 57);
  static const TextStyle cardTitleTextStyle = TextStyle(
      fontSize: 16, color: primaryAppColorDark, fontWeight: FontWeight.w300);
  static const TextStyle cardSubTitleTextStyle =
      TextStyle(fontSize: 13, color: primaryAppColorDark);

  static ThemeData get appTheme => ThemeData(
      primaryColor: primaryAppColor,
      primaryColorDark: primaryAppColorDark,
      accentColor: accentAppColor,
      secondaryHeaderColor: secondaryHeaderAppColor,
      iconTheme: IconThemeData(color: primaryAppColorDark),
      textTheme: TextTheme(
        headline: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        subhead: TextStyle(fontSize: 16, color: primaryAppColorDark),
        body1: TextStyle(
            fontSize: 21, color: Colors.black, fontWeight: FontWeight.w300),
        body2: TextStyle(
            fontSize: 21,
            color: primaryAppColorDark,
            fontWeight: FontWeight.w300),
        caption: TextStyle(
            fontSize: 26,
            color: primaryAppColorDark,
            fontWeight: FontWeight.w500),
      ));
}
