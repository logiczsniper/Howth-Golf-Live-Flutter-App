import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/objects.dart';

class Constants {
  static String get appName => "Howth Golf Live";

  static const String currentText = "Current";
  static const String archivedText = "Archived";

  static const String competitionsText = "Competitions";
  static const String appHelpText = "App Help";

  static List<Map<String, dynamic>> _appHelpEntryData = [
    {
      'title': 'Gaining Admin Privileges',
      'subtitle': 'Highest level permissions, e.g. adding new tournaments',
      'steps': [
        {
          'title': 'Return to the app help page',
          'data': 'Click the arrow icon in the top left corner of this page'
        },
        {
          'title': 'Show the text field',
          'data': 'Click the admin icon in the top right corner of the page'
        },
        {
          'title': 'Enter your admin code',
          'data': 'Click on the box that has appeared, type in your admin code'
        },
        {
          'title': 'Submit entered code',
          'data': 'Click the admin icon in the top right corner of the page'
        },
      ]
    },
    {
      'title': 'Competition Score Access',
      'subtitle':
          'Low level permissions, e.g. modify scores of a specific competition',
      'steps': [
        {
          'title': 'Return to the competitions page',
          'data': 'Click the home icon in the top right corner of this page'
        },
        {
          'title': 'Locate competition to be accessed',
          'data': 'Scroll through the current and archived competitions'
        },
        {
          'title': 'Click on the compeition',
          'data': 'Tap anywhere on it\'s card'
        },
        {
          'title': 'Show the text field',
          'data': 'Click the admin icon in the top right corner of the page'
        },
        {
          'title': 'Enter your competition code',
          'data':
              'Click on the box that has appeared, type in your competition code'
        },
        {
          'title': 'Submit entered code',
          'data': 'Click the admin icon in the top right corner of the page'
        },
      ]
    }
  ];
  static List<AppHelpEntry> appHelpEntries =
      new List<AppHelpEntry>.generate(_appHelpEntryData.length, (int index) {
    return AppHelpEntry.buildFromMap(_appHelpEntryData[index]);
  });

  static const Color primaryAppColor = Colors.white;
  static const Color primaryAppColorDark = Color.fromARGB(255, 187, 187, 187);
  static const Color accentAppColor = Color.fromARGB(255, 153, 0, 0);
  static const Color cardAppColor = Color.fromARGB(255, 248, 248, 248);
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
