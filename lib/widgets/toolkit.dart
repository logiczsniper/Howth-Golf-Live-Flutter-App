import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/scroll_behavior.dart';
import 'package:showcaseview/showcase.dart';

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
      gradient: LinearGradient(
          colors: [Palette.card, Color.fromARGB(255, 238, 238, 238)]),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(13.0));

  /// Some common methods used in various pages and widgets.
  static Card getCard(Widget child) => Card(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          decoration: roundedRectBoxDecoration,
          child: child));

  /// The maroon decoration around the [text].
  static Decoration get scoreDecoration => ShapeDecoration(
      color: Palette.maroon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)));

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
      width: 32.0,
      child: Padding(
          child: Align(
              alignment: Alignment.center,
              child: Text(holeNumber.toString(),
                  style: TextStyles.cardSubTitle.copyWith(
                      color: Palette.inMaroon, fontWeight: FontWeight.bold))),
          padding: EdgeInsets.all(4.0)),
      decoration: BoxDecoration(
          color: Palette.maroon,
          border: Border.all(color: Palette.maroon, width: 1.5),
          borderRadius: BorderRadius.circular(13.0)));

  static Text getLeadingText(String text) => Text(text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyles.leadingChild);

  /// The text that appears in a form.
  static Widget getFormText(String text) => Padding(
      padding: EdgeInsets.only(top: 2.0, bottom: 8.0),
      child: Center(
          child: Text(
        Strings.note + text,
        textAlign: TextAlign.center,
        style: TextStyles.form,
      )));

  /// A simple button to navigate back to [Competitions] page.
  static IconButton getHomeButton(BuildContext context) => IconButton(
      icon: Icon(Icons.home),
      tooltip: Strings.returnHome,
      onPressed: () => Routes.of(context).toCompetitions());

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
          style: TextStyles.cardSubTitle.apply(fontSizeDelta: -1.5),
        ),
        Text(relevantNumber,
            style: TextStyle(
                fontSize: 22.5,
                color: Palette.dark,
                fontWeight: FontWeight.w400))
      ]);

  static Showcase showcase(
          {@required BuildContext context,
          @required GlobalKey key,
          String description,
          Widget child}) =>
      Showcase(
          key: key,
          description: description ?? "",
          descTextStyle: TextStyles.description,
          showArrow: false,
          textColor: Palette.dark,
          overlayColor: Palette.dark,
          child: child ?? Container());

  static SnackBar snackbar(String text, IconData iconData,
          {Duration duration}) =>
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Palette.maroon,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        duration: duration ?? Duration(seconds: 5),
      );

  static FloatingActionButton createButton(
      {@required BuildContext context, String text, int id}) {
    if (text == Strings.newHole) assert(id != null);
    assert(text == Strings.newCompetition || text == Strings.newHole);

    return FloatingActionButton.extended(
      icon: Icon(
        Icons.add_circle,
        color: Palette.inMaroon,
      ),
      label: Text(
        text,
        style: TextStyle(fontSize: 15, color: Palette.inMaroon),
      ),
      onPressed: () {
        switch (text) {
          case Strings.newCompetition:
            Routes.of(context).toCompetitionCreation();
            break;
          case Strings.newHole:
            Routes.of(context).toHoleCreation(id);
            break;
        }
      },
    );
  }

  /// Returns the centered and padded [Row] containing the [howthText] and the
  /// [currentData.opposition] text in the correct order depending on
  /// [currentData.location.isHome].
  static Container getVersus(BuildContext context, String opposition,
          String howthText, GlobalKey _awayTeamKey) =>
      Container(
          margin: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 2.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.0),
              color: Colors.transparent),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  howthText,
                  textAlign: TextAlign.right,
                  style: TextStyles.form.copyWith(
                      color: Palette.dark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5),
                ),
              ),
              Container(
                  width: 42.5,
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      color: Palette.maroon,
                      borderRadius: BorderRadius.circular(13.0)),
                  child: Text(
                    Strings.versus,
                    textAlign: TextAlign.center,
                    style: TextStyles.helpTitle.copyWith(
                        fontWeight: FontWeight.w900, color: Palette.inMaroon),
                  ),
                  padding: EdgeInsets.all(10.0)),
              Expanded(
                  child: UIToolkit.showcase(
                      context: context,
                      key: _awayTeamKey,
                      description: Strings.oppositionTeam,
                      child: Text(
                        opposition,
                        textAlign: TextAlign.left,
                        style: TextStyles.form.copyWith(
                            color: Palette.dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.5),
                      )))
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0));

  static Widget exampleHole(
      BuildContext context,
      GlobalKey _holeKey,
      GlobalKey _playersKey,
      GlobalKey _holeHomeScoreKey,
      GlobalKey _holeAwayScoreKey,
      GlobalKey _holeNumberKey,
      GlobalKey _oppositionKey) {
    Hole hole = Hole.example;
    return UIToolkit.showcase(
        context: context,
        key: _holeKey,
        description: Strings.hole,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: Palette.card.withAlpha(240),
                borderRadius: BorderRadius.circular(13.0)),
            child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      /// Home team section.
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                            /// Home player.
                            Expanded(
                                child: UIToolkit.showcase(
                                    context: context,
                                    key: _playersKey,
                                    description: Strings.players,
                                    child: Container(
                                        padding: EdgeInsets.all(17.5),
                                        alignment: Alignment.centerLeft,
                                        child: Text("Howth player(s)",
                                            textAlign: TextAlign.left,
                                            style: TextStyles.cardSubTitle
                                                .copyWith(
                                                    color: Palette.darker))))),

                            /// Home score.
                            UIToolkit.showcase(
                                context: context,
                                key: _holeHomeScoreKey,
                                description: Strings.holeHowthScore,
                                child: Container(
                                    child: Text(hole.holeScore.howth,
                                        style: TextStyles.leadingChild.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    padding: EdgeInsets.fromLTRB(
                                        16.0, 3.0, 12.0, 3.0))),

                            /// Hole Number
                            UIToolkit.showcase(
                                context: context,
                                key: _holeNumberKey,
                                description: Strings.currentHoleNumber,
                                child: UIToolkit.getHoleNumberDecorated(
                                    hole.holeNumber)),

                            /// Opposition score.
                            UIToolkit.showcase(
                                context: context,
                                key: _holeAwayScoreKey,
                                description: Strings.holeOppositionScore,
                                child: Container(
                                    child: Text(hole.holeScore.opposition,
                                        style: TextStyles.leadingChild.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    padding: EdgeInsets.fromLTRB(
                                        12.0, 3.0, 16.0, 3.0))),

                            /// Opposition player.
                            Expanded(
                                child: UIToolkit.showcase(
                                    context: context,
                                    key: _oppositionKey,
                                    description: Strings.opposition,
                                    child: Container(
                                        padding: EdgeInsets.all(17.5),
                                        alignment: Alignment.centerRight,
                                        child: Text("Opposing player(s)/club",
                                            textAlign: TextAlign.right,
                                            style: TextStyles.cardSubTitle
                                                .copyWith(
                                                    color: Palette.darker))))),
                          ]))
                    ]))));
  }
}
