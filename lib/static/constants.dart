import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/objects.dart';

class Constants {
  static String get appName => "Howth Golf Live";

  static const String currentText = "Current";
  static const String archivedText = "Archived";

  static const String competitionsText = "Competitions";
  static const String appHelpText = "App Help";

  static const String activeAdminText = "activeAdmin";
  static const String activeCompetitionText = "activeCompetitions";

  static List<Map<String, dynamic>> _appHelpEntryData = [
    {
      'title': 'Gaining Admin Privileges',
      'subtitle': 'Highest level permissions',
      'steps': [
        {
          'title': 'Return to the app help page',
          'data':
              'Click the arrow icon in the top left corner of this page to go back to the App Help page.'
        },
        {
          'title': 'Show the text field',
          'data':
              'Click the admin icon in the top right corner of the page. A text field should appear.'
        },
        {
          'title': 'Enter your admin code',
          'data':
              'Click on the text field that has appeared & type in your admin code.'
        },
        {
          'title': 'Submit entered code',
          'data':
              'Click the admin icon in the top right corner of the page. The text field vanishes.'
        },
      ]
    },
    {
      'title': 'Competition Score Access',
      'subtitle': 'Low level permissions',
      'steps': [
        {
          'title': 'Return to the competitions page',
          'data':
              'Click the home icon in the top right corner of this page to return to the Competitions page.'
        },
        {
          'title': 'Locate competition to be accessed',
          'data':
              'Scroll through the current & archived competitions to find your competition.'
        },
        {
          'title': 'Click on the compeition',
          'data':
              'Tap anywhere on it\'s card to enter page with the details of your competition.'
        },
        {
          'title': 'Show the text field',
          'data':
              'Click the admin icon in the top right corner of the page. A text field should appear.'
        },
        {
          'title': 'Enter your competition code',
          'data':
              'Click on the text field that has appeared & type in your competition code.'
        },
        {
          'title': 'Submit entered code',
          'data':
              'Click the admin icon in the top right corner of the page. The text field vanishes.'
        },
      ]
    },
    {
      'title': 'General App Usage',
      'subtitle': 'Understanding Howth Golf Live',
      'steps': [
        {
          'title': 'Competition score display',
          'data':
              'At the top of each competition page, the score on the left is always Howth.'
        },
        {
          'title': 'Refresh all competitions',
          'data':
              'There is no need- the Competitions page is always up to date.'
        },
        {
          'title': 'Refresh specific competition',
          'data':
              'On a specific competition page, drag the list from top to bottom.'
        },
        {
          'title': 'Understanding competition details',
          'data':
              'At the top middle of a specific competition page: opposition, location & lastly the time.'
        },
        {
          'title': 'Searching for a competition',
          'data':
              'In the Competitions page, hit the magnifying glass icon in the top right & enter search text.'
        },
      ]
    }
  ];
  static List<AppHelpEntry> appHelpEntries =
      new List<AppHelpEntry>.generate(_appHelpEntryData.length, (int index) {
    return AppHelpEntry.buildFromMap(_appHelpEntryData[index]);
  });

  static BoxDecoration rightSideBoxDecoration = BoxDecoration(
      border: Border(
          right: BorderSide(width: 1.5, color: Constants.accentAppColor)));
  static BoxDecoration roundedRectBoxDecoration = BoxDecoration(
      color: Constants.cardAppColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10.0));

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
