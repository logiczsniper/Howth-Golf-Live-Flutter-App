import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/widgets/scroll_behavior.dart';

import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/themes.dart';

class UIToolkit {
  /// Serves as the builder method for the [MaterialApp].
  ///
  /// Uses [CustomScrollBehavior] to improve app aesthetic.
  static ScrollConfiguration appBuilder(BuildContext context, Widget child) =>
      ScrollConfiguration(behavior: CustomScrollBehavior(), child: child);

  /// Some common widgets.
  static BoxDecoration rightSideBoxDecoration = BoxDecoration(
      border: Border(right: BorderSide(width: 1.5, color: Palette.maroon)));

  static BoxDecoration leftSideBoxDecoration = BoxDecoration(
      border: Border(left: BorderSide(width: 1.5, color: Palette.maroon)));

  static BoxDecoration topSideBoxDecoration = BoxDecoration(
      border: Border(top: BorderSide(width: 1.5, color: Palette.maroon)));

  static BoxDecoration bottomSideBoxDecoration = BoxDecoration(
      border: Border(bottom: BorderSide(width: 1.5, color: Palette.maroon)));

  static BoxDecoration verticalSideBoxDecoration = BoxDecoration(
      border: Border(
          bottom: BorderSide(width: 1.5, color: Palette.maroon),
          top: BorderSide(width: 1.5, color: Palette.maroon)));

  static BoxDecoration roundedRectBoxDecoration = BoxDecoration(
/*       boxShadow: [
        BoxShadow(
            color: Palette.dark,
            spreadRadius: 0.5,
            blurRadius: 4.5,
            offset: Offset(5, 5)),
        BoxShadow(
            color: Palette.light,
            spreadRadius: 0.5,
            blurRadius: 3.5,
            offset: Offset(-5, -5))
      ],*/
      gradient: LinearGradient(
          colors: [Palette.card, Color.fromARGB(255, 236, 236, 236)]),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10.0));

  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Palette.maroon, width: 1.8),
      borderRadius: const BorderRadius.all(const Radius.circular(10.0)));

  /// Some common methods used in various pages and widgets.
  static Card getCard(Widget child) => Card(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          decoration: roundedRectBoxDecoration,
          child: child));

  /// The maroon decoration around the [text].
  static Decoration get scoreDecoration => ShapeDecoration(
      color: Palette.maroon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));

  static Center get loadingSpinner => Center(
          child: SpinKitPulse(
        color: Palette.dark,
        size: 45,
        duration: Duration(milliseconds: 350),
      ));

  /// Returns the [Hole.holeNumber] with apt decoration - a smalled
  /// rounded box with padding.
  static Container getHoleNumberDecorated(int holeNumber) => Container(
      key: ValueKey(DateTime.now()),
      margin: EdgeInsets.symmetric(vertical: 2.0),
      padding: EdgeInsets.all(2.5),
      child: Padding(
          child: Text(holeNumber.toString().padLeft(2, "0"),
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
      onPressed: () => Navigator.of(context).popUntil(
          ModalRoute.withName(Routes.home + Strings.competitionsText)));

  /// Handles special situations with [snapshot].
  ///
  /// If an error occurs, returns a [Center] widget to notify the user
  /// to contact the developer.
  /// If the snapshot is still loading, return a loading widget, the
  /// [SpinKitPulse].

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

  static SnackBar snackbar(String text) => SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
      );

  static FloatingActionButton createButton(
      {@required BuildContext context, String text, int id}) {
    if (text == Strings.newHole) assert(id != null);
    assert(text == Strings.newCompetition || text == Strings.newHole);

    return FloatingActionButton.extended(
      icon: Icon(
        Icons.add,
        color: Palette.inMaroon,
      ),
      label: Text(
        text,
        style: TextStyle(fontSize: 14, color: Palette.inMaroon),
      ),
      onPressed: () {
        switch (text) {
          case Strings.newCompetition:
            Routes.toCompetitionCreation(context);
            break;
          case Strings.newHole:
            Routes.toHoleCreation(context, id);
            break;
        }
      },
    );
  }

  /// Returns the centered and padded [Row] containing the [howthText] and the
  /// [currentData.opposition] text in the correct order depending on
  /// [currentData.location.isHome].
  static Container getVersus(
          bool isHome, String opposition, String howthText) =>
      Container(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                isHome ? howthText : opposition,
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
                !isHome ? howthText : opposition,
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
  static const TextStyle scoreCardTextStyle = TextStyle(
    fontSize: 13,
    color: Palette.dark,
  );
}
