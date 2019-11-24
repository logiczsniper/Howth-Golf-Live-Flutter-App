import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:howth_golf_live/static/objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Toolkit {
  static String get appName => "Howth Golf Live";

  /// App page texts. Also used for fetching data from firestore.
  /// ___________________________________________________________________________________________
  static const String currentText = "Current";
  static const String archivedText = "Archived";
  static const String competitionsText = "Competitions";
  static const String appHelpText = "App Help";

  /// When getting data from preferences, it is vital that these values are used as keys.
  /// ___________________________________________________________________________________________
  static const String activeAdminText = "activeAdmin";
  static const String activeCompetitionText = "activeCompetitions";

  /// The actual instructions for each of the guides in app help.
  /// ___________________________________________________________________________________________
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

  /// Converting the hidden data (above) into a useful list of AppHelpEntries. These are constant.
  /// ___________________________________________________________________________________________
  static List<AppHelpEntry> appHelpEntries =
      new List<AppHelpEntry>.generate(_appHelpEntryData.length, (int index) {
    return AppHelpEntry.fromMap(_appHelpEntryData[index]);
  });

  /// Some common widgets.
  /// ___________________________________________________________________________________________
  static BoxDecoration rightSideBoxDecoration = BoxDecoration(
      border:
          Border(right: BorderSide(width: 1.5, color: Toolkit.accentAppColor)));
  static BoxDecoration roundedRectBoxDecoration = BoxDecoration(
      color: Toolkit.cardAppColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10.0));
  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Toolkit.accentAppColor, width: 1.8),
      borderRadius: const BorderRadius.all(const Radius.circular(10.0)));

  /// Some common methods used in various pages and widgets.
  /// ___________________________________________________________________________________________
  static Card getCard(Widget child) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 1.85,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: Toolkit.roundedRectBoxDecoration, child: child));
  }

  /// Use [Navigator] to take the user to the main compeitions page.
  ///
  /// The [SharedPreferences] instance must be fetched and passed as
  /// an argument to [pushNamed] so the new page can determine whether or
  /// not the user is an admin and if so, adjust how it displays certain
  /// elements.
  static void navigateTo(BuildContext context, String destination) {
    final preferences = SharedPreferences.getInstance();
    preferences.then((SharedPreferences preferences) {
      Navigator.pushNamed(context, '/' + destination,
          arguments: Privileges.fromPreferences(preferences));
    });
  }

  static Stream<QuerySnapshot> getStream() {
    return Firestore.instance
        .collection(Toolkit.competitionsText.toLowerCase())
        .snapshots();
  }

  /// Fetch and parse (to [DataBaseEntry] objects) all of the competitions
  /// from [Firestore]. The [document] contains the data which, in turn,
  /// contains the [rawElements] in the database.
  static List<DataBaseEntry> getDataBaseEntries(DocumentSnapshot document) {
    /// The [entries] in my [Firestore] instance.
    List<dynamic> rawElements = document.data.entries.toList()[0].value;

    /// Those same [entries] but in a structured format- [DataBaseEntry].
    List<DataBaseEntry> parsedElements =
        new List<DataBaseEntry>.generate(rawElements.length, (int index) {
      return DataBaseEntry.fromJson(rawElements[index]);
    });
    return parsedElements;
  }

  static Text getLeadingText(String text) {
    return Text(text,
        overflow: TextOverflow.fade,
        maxLines: 1,
        style: Toolkit.leadingChildTextStyle);
  }

  /// Builds a leading child's column, where [smallText] is the shrunken
  /// text that goes above the [relevantNumber].
  static Column getLeadingColumn(String smallText, String relevantNumber) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            smallText,
            style: Toolkit.cardSubTitleTextStyle.apply(fontSizeDelta: -1.5),
          ),
          Text(relevantNumber,
              style: TextStyle(
                  fontSize: 21.5,
                  color: Toolkit.primaryAppColorDark,
                  fontWeight: FontWeight.w400))
        ]);
  }

  /// Colors and text styles used throughout the app. Ensures consistency in the theme.
  /// ___________________________________________________________________________________________
  static const Color primaryAppColor = Colors.white;
  static const Color primaryAppColorDark = Color.fromARGB(255, 187, 187, 187);
  static const Color accentAppColor = Color.fromARGB(255, 153, 0, 0);
  static const Color cardAppColor = Color.fromARGB(255, 248, 248, 248);
  static const Color secondaryHeaderAppColor = Color.fromARGB(255, 57, 57, 57);

  /// Text Styles.
  /// ___________________________________________________________________________________________
  static const TextStyle cardTitleTextStyle = TextStyle(
      fontSize: 16, color: primaryAppColorDark, fontWeight: FontWeight.w300);
  static const TextStyle cardSubTitleTextStyle =
      TextStyle(fontSize: 13, color: primaryAppColorDark);
  static const TextStyle hintTextStyle =
      TextStyle(fontSize: 16, color: primaryAppColorDark);
  static const TextStyle leadingChildTextStyle = TextStyle(
      fontSize: 20,
      color: Toolkit.primaryAppColorDark,
      fontWeight: FontWeight.w400);
}
