import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/domain/models.dart';

import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/themes.dart';
import 'package:howth_golf_live/widgets/scroll_behavior.dart';

class UIToolkit {
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

  static BoxDecoration _roundedRectBoxDecoration = BoxDecoration(
      shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10.0));

  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Palette.maroon, width: 1.8),
      borderRadius: const BorderRadius.all(const Radius.circular(10.0)));

  /// Some common methods used in various pages and widgets.
  static Card getCard(Widget child) => Card(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          decoration: _roundedRectBoxDecoration,
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
          text: double.tryParse(score).toInt() == 0 && Strings.isFraction(score)
              ? ""
              : double.tryParse(score).toInt().toString(),
          style: TextStyle(
              fontSize: 21,
              color: Palette.inMaroon,
              fontWeight: FontWeight.w400),
          children: <TextSpan>[
            /// Secondary text value (fractional).
            TextSpan(
                text: Strings.isFraction(score) ? "1/2" : "",
                style: TextStyle(
                    fontSize: 21,
                    color: Palette.inMaroon,
                    fontFeatures: [FontFeature.enable('frac')]))
          ]));

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
              style: UIToolkit.cardSubTitleTextStyle),
          padding: EdgeInsets.all(4.0)),
      decoration: BoxDecoration(
          color: Palette.light,
          border: Border.all(color: Palette.maroon, width: 1.5),
          borderRadius: BorderRadius.circular(9.0)));

  static Text getLeadingText(String text) => Text(text,
      overflow: TextOverflow.fade,
      maxLines: 1,
      style: UIToolkit.leadingChildTextStyle);

  /// The text that appears in a form.
  static Widget getFormText(String text) => Center(
          child: Text(
        Strings.note + text,
        textAlign: TextAlign.center,
        style: Themes.formStyle,
      ));

  /// A simple button to navigate back to [Competitions] page.
  static IconButton getHomeButton(BuildContext context) => IconButton(
        icon: Icon(Icons.home),
        tooltip: Strings.returnHome,
        onPressed: () => Routes.navigateTo(context, Strings.competitionsText),
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
          Icon(Icons.error),
          Text(
            Strings.error,
            style: UIToolkit.cardSubTitleTextStyle,
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

  /// Builds a leading child's column, where [smallText] is the shrunken
  /// text that goes above the [relevantNumber].
  static Column getLeadingColumn(String smallText, String relevantNumber) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(
          smallText,
          style: UIToolkit.cardSubTitleTextStyle.apply(fontSizeDelta: -1.5),
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
                style: Themes.formStyle,
              )),
              Padding(
                  child: Icon(
                    FontAwesomeIcons.fistRaised,
                    size: 16.7,
                  ),
                  padding: EdgeInsets.all(3.0)),
              Expanded(
                  child: Text(
                !currentData.location.isHome
                    ? howthText
                    : currentData.opposition,
                textAlign: TextAlign.left,
                style: Themes.formStyle,
              ))
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 15.0));

  /// Text Styles. TODO: remove these eventually
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
}
