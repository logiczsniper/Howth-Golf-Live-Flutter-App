import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/static/database_entry.dart';

import 'package:howth_golf_live/static/privileges.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Toolkit {
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
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          decoration: Toolkit.roundedRectBoxDecoration,
          child: child));

  /// The maroon decoration around the [text].
  static Decoration get scoreDecoration => ShapeDecoration(
      color: Palette.maroon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));

  /// Displays the text of the score.
  ///
  /// If the value is not whole and not equal to 0, it
  /// will display a fraction. Else, will display the whole number.
  static Widget scoreText(String score, String oldScore) => RichText(

      /// Uses a [Key] to distinguish between the children widgets of the
      /// [AnimatedSwitcher], forcing the fade transition to occur.
      key: score == oldScore ? null : ValueKey(DateTime.now()),

      /// Primary text value.
      text: TextSpan(
          text: double.tryParse(score).toInt() == 0 && Toolkit.isFraction(score)
              ? ""
              : double.tryParse(score).toInt().toString(),
          style: TextStyle(
              fontSize: 21,
              color: Palette.buttonText,
              fontWeight: FontWeight.w400),
          children: <TextSpan>[
            /// Secondary text value (fractional).
            TextSpan(
                text: Toolkit.isFraction(score) ? "1/2" : "",
                style: TextStyle(
                    fontSize: 21,
                    color: Palette.buttonText,
                    fontFeatures: [FontFeature.enable('frac')]))
          ]));

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
      .collection(Strings.competitionsText.toLowerCase())
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

  /// Turn a list of players, [playerList], into one string with
  /// those individual player names separated by commas, apart from the last
  /// player in the list.
  static String formatPlayerList(List playerList) {
    String output = '';
    bool isLastPlayer = false;
    for (String player in playerList) {
      output += player.toString();
      isLastPlayer = playerList.indexOf(player) == playerList.length - 1;
      if (!isLastPlayer) {
        output += ', ';
      }
    }
    return output;
  }

  /// Returns the [Hole.holeNumber] with apt decoration - a smalled
  /// rounded box with padding.
  static Container getHoleNumberDecorated(int holeNumber) => Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      padding: EdgeInsets.all(2.5),
      child: Padding(
          child: Text(
              holeNumber.toString().length == 1
                  ? "0$holeNumber"
                  : holeNumber.toString(),
              style: Toolkit.cardSubTitleTextStyle),
          padding: EdgeInsets.all(4.0)),
      decoration: BoxDecoration(
          color: Palette.light,
          border: Border.all(color: Palette.maroon, width: 1.5),
          borderRadius: BorderRadius.circular(9.0)));

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

  /// A simple button to navigate back to [Competitions] page.
  static IconButton getHomeButton(BuildContext context) => IconButton(
        icon: Icon(Icons.home),
        tooltip: 'Tap to return to home!',
        onPressed: () => Toolkit.navigateTo(context, Strings.competitionsText),
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

  /// Returns the centered and padded [Row] containing the [howthText] and the
  /// [currentData.opposition] text in the correct order depending on
  /// [currentData.location.isHome].
  static Container getVersus(DataBaseEntry currentData, String howthText) =>
      Container(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                currentData.location.isHome
                    ? howthText
                    : currentData.opposition,
                textAlign: TextAlign.right,
                style: Toolkit.formTextStyle,
              )),
              Padding(
                  child: Icon(
                    FontAwesomeIcons.fistRaised,
                    color: Palette.dark,
                    size: 16.7,
                  ),
                  padding: EdgeInsets.all(3.0)),
              Expanded(
                  child: Text(
                !currentData.location.isHome
                    ? howthText
                    : currentData.opposition,
                textAlign: TextAlign.left,
                style: Toolkit.formTextStyle,
              ))
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 15.0));

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
  static const TextStyle noDataTextStyle =
      TextStyle(fontSize: 18, color: Palette.dark, fontWeight: FontWeight.w300);
  static const TextStyle titleTextStyle = TextStyle(
      color: Palette.dark,
      fontFamily: "CormorantGaramond",
      fontSize: 27.0,
      height: 0.95);
}
