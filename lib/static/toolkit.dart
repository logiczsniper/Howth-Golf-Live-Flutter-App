import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:howth_golf_live/static/database_entry.dart';

import 'package:howth_golf_live/static/privileges.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Toolkit {
  static String get appName => "Howth Golf Live";

  /// App page texts. Also used for fetching data from firestore and app routing.
  static const String home = "/";
  static const String currentText = "Current";
  static const String archivedText = "Archived";
  static const String competitionsText = "Competitions";
  static const String helpText = "App Help";

  /// Paths to graphics used in the app.
  static const String iconPath = "lib/graphics/icon.png";

  /// When getting data from preferences, it is vital that these values are used as keys.
  static const String activeAdminText = "activeAdmin";
  static const String activeCompetitionsText = "activeCompetitions";

  /// Serves as the builder method for the [MaterialApp].
  ///
  /// Uses [CustomScrollBehavior] to improve app aesthetic.
  static ScrollConfiguration appBuilder(BuildContext context, Widget child) =>
      ScrollConfiguration(behavior: CustomScrollBehavior(), child: child);

  /// Some common widgets.
  static BoxDecoration rightSideBoxDecoration = BoxDecoration(
      border: Border(right: BorderSide(width: 1.5, color: Palette.maroon)));

  static BoxDecoration bottomSideBoxDecoration = BoxDecoration(
      border: Border(bottom: BorderSide(width: 1.5, color: Palette.maroon)));

  static BoxDecoration verticalSideBoxDecoration = BoxDecoration(
      border: Border(
          bottom: BorderSide(width: 1.5, color: Palette.maroon),
          top: BorderSide(width: 1.5, color: Palette.maroon)));

  static BoxDecoration roundedRectBoxDecoration = BoxDecoration(
      color: Palette.card,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10.0));

  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Palette.maroon, width: 1.8),
      borderRadius: const BorderRadius.all(const Radius.circular(10.0)));

  /// Some common methods used in various pages and widgets.
  static Card getCard(Widget child) => Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 1.85,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
          decoration: Toolkit.roundedRectBoxDecoration, child: child));

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

  static Stream<QuerySnapshot> get stream => Firestore.instance
      .collection(Toolkit.competitionsText.toLowerCase())
      .snapshots();

  /// Fetch and parse (to [DataBaseEntry] objects) all of the competitions
  /// from [Firestore]. The [document] contains the data which, in turn,
  /// contains the [rawElements] in the database.
  static List<DataBaseEntry> getDataBaseEntries(DocumentSnapshot document) {
    /// The [entries] in my [Firestore] instance, at index 1- the admin code is at 0.
    List<dynamic> rawElements = document.data.entries.toList()[1].value;

    /// Those same [entries] but in a structured format- [DataBaseEntry].
    List<DataBaseEntry> parsedElements = List<DataBaseEntry>.generate(
        rawElements.length,
        (int index) => DataBaseEntry.fromJson(rawElements[index]));

    return parsedElements;
  }

  static Text getLeadingText(String text) => Text(text,
      overflow: TextOverflow.fade,
      maxLines: 1,
      style: Toolkit.leadingChildTextStyle);

  /// The text that appears in a form.
  static Widget getFormText(String text) => Center(
          child: Text(
        "NOTE: " + text,
        textAlign: TextAlign.center,
        style: Toolkit.formTextStyle,
      ));

  static IconButton getHomeButton(BuildContext context) => IconButton(
        icon: Icon(Icons.home),
        tooltip: 'Tap to return to home!',
        onPressed: () => Toolkit.navigateTo(context, Toolkit.competitionsText),
        color: Palette.dark,
      );

  /// Handles special situations with [snapshot].
  ///
  /// If an error occurs, returns a [Center] widget to notify the user
  /// to contact the developer.
  /// If the snapshot is still loading, return a loading widget, the
  /// [SpinKitPulse].
  static Center checkSnapshot(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.error != null)
      return Center(
          child: Column(
        children: <Widget>[
          Icon(Icons.error, color: Palette.dark),
          Text(
            'Oof, please email the address in App Help to report this error.',
            style: Toolkit.cardSubTitleTextStyle,
          )
        ],
      ));

    if (!snapshot.hasData)
      return Center(
          child: SpinKitPulse(
        color: Palette.dark,
      ));

    return null;
  }

  /// Determines whether [score] is a string containing a fraction or whole
  /// number.
  static bool isFraction(String score) =>
      double.tryParse(score) - double.tryParse(score).toInt() != 0;

  /// Builds a leading child's column, where [smallText] is the shrunken
  /// text that goes above the [relevantNumber].
  static Column getLeadingColumn(String smallText, String relevantNumber) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(
          smallText,
          style: Toolkit.cardSubTitleTextStyle.apply(fontSizeDelta: -1.5),
        ),
        Text(relevantNumber,
            style: TextStyle(
                fontSize: 21.5,
                color: Palette.dark,
                fontWeight: FontWeight.w400))
      ]);

  /// Text Styles.
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
  static const TextStyle formTextStyle =
      TextStyle(fontSize: 14, color: Palette.dark);
  static const TextStyle titleTextStyle = TextStyle(
      color: Palette.dark,
      fontFamily: "CormorantGaramond",
      fontSize: 27.0,
      height: 0.95);
}
