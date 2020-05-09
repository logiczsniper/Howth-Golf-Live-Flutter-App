import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase.dart';

import 'dart:ui';

import 'package:howth_golf_live/app/creation/create_competition.dart';
import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/creation/create_hole.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/custom_modal_configuration.dart';
import 'package:howth_golf_live/widgets/scroll_behavior.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/style/palette.dart';

/// A collection of widget and decoration builders used throughout
/// the app.
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
      color: Palette.card,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(13.0));

  /// Uses [CustomTransitionConfiguration] instead of the standard.
  static ModalConfiguration modalConfiguration({bool isDeletion = false}) =>
      CustomTransitionConfiguration(
        barrierColor:
            isDeletion ? Palette.darker.withAlpha(138) : Palette.light,
      );

  /// Some common methods used in various pages and widgets.
  static Card getCard(Widget child) => Card(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          decoration: roundedRectBoxDecoration,
          child: child));

  /// The maroon decoration around the [field].
  static Decoration get scoreDecoration => ShapeDecoration(
      color: Palette.maroon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)));

  static Center get loadingSpinner => Center(
        child: SpinKitPulse(
          color: Palette.dark,
          size: 45,
          duration: const Duration(milliseconds: 350),
        ),
      );

  /// Returns the [Hole.holeNumber] with apt decoration - a smalled
  /// rounded box with padding.
  static Container getHoleNumberDecorated(dynamic holeNumber) => Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      padding: EdgeInsets.all(2.5),
      width: 32.0,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            holeNumber.toString(),
            textAlign: TextAlign.center,
            style: TextStyles.cardSubTitle.copyWith(
              color: Palette.inMaroon,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
          color: Palette.maroon,
          border: Border.all(color: Palette.maroon, width: 1.5),
          borderRadius: BorderRadius.circular(13.0)));

  static Text getLeadingText(String text) => Text(text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyles.leadingChild);

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

  /// Builds a [Showcase] widget with preset parameters
  /// for saving time such as [descTextStyle], [showArrow], [textColor],
  /// [overlayColor] and adds padding to [description].
  static Showcase showcase({
    @required BuildContext context,
    @required GlobalKey key,
    String description,
    Widget child,
  }) =>
      Showcase(
        key: key,
        description: "  $description  " ?? "",
        descTextStyle: TextStyles.description,
        showArrow: false,
        textColor: Palette.dark,
        overlayColor: Palette.dark,
        child: child ?? Container(),
      );

  /// Builds the standard app [SnackBar] that is consistent.
  static SnackBar snackbar(
    String text,
    IconData iconData, {
    Duration duration,
  }) =>
      SnackBar(
        duration: duration ?? const Duration(seconds: 7),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Palette.maroon,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      );

  static Widget svgHowthLogo({
    double width = 70.0,
    int opacity = 220,
    Color color,
  }) {
    return SvgPicture.asset(
      Strings.iconPath,
      fit: BoxFit.fill,
      allowDrawingOutsideViewBox: true,
      width: width,
      placeholderBuilder: (context) => SizedBox(
        width: width - 5,
        height: (width - 5) * 1.45,
        child: Container(color: Palette.light),
      ),
    );
  }

  /// Builds a [FloatingActionButton].
  ///
  /// [primaryText] is the main text of the button, bolded and centerd.
  /// [secondaryText] is the text below the main text, thinner.
  ///
  /// With the [CustomModalConfiguration], it shows either the
  /// [CreateCompetition] or [CreateHole] modals. It knows which to show
  /// via [primaryText].
  static FloatingActionButton createButton({
    @required BuildContext context,
    String primaryText,
    String secondaryText,
    int id,
  }) {
    if (primaryText == Strings.newHole) assert(id != null);
    assert(primaryText == Strings.newCompetition ||
        primaryText == Strings.newHole);
    assert(secondaryText == Strings.tapEditHole ||
        secondaryText == Strings.tapEditCompetition);

    return FloatingActionButton.extended(
      label: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.add_circle,
                  color: Palette.inMaroon,
                ),
              ),
              Text(
                primaryText,
                style: TextStyle(
                    fontSize: 15,
                    color: Palette.inMaroon,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            secondaryText,
            style: TextStyle(fontSize: 12, color: Palette.inMaroon),
          ),
        ],
      ),
      onPressed: () => showModal(
        context: context,
        configuration: modalConfiguration(),
        builder: (context) {
          switch (primaryText) {
            case Strings.newCompetition:
              return CreateCompetition();
              break;
            case Strings.newHole:
              return CreateHole(id);
              break;
            default:
              throw Exception;
          }
        },
      ),
    );
  }

  /// Returns the centered and padded [Row] containing the [howthText] and the
  /// [currentData.opposition] text in the correct order depending on
  /// [currentData.location.isHome].
  static Container getVersus(
    BuildContext context,
    int id,
    GlobalKey _awayTeamKey,
  ) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
        margin: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.0),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Text(
                Strings.homeAddress,
                textAlign: TextAlign.right,
                style: TextStyles.form.copyWith(
                    color: Palette.dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.5),
              ),
            ),
            Container(
              width: 42.5,
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                  color: Palette.maroon,
                  borderRadius: BorderRadius.circular(13.0)),
              child: Text(
                Strings.versus,
                textAlign: TextAlign.center,
                style: TextStyles.helpTitle.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Palette.inMaroon,
                ),
              ),
            ),
            Expanded(
              child: UIToolkit.showcase(
                context: context,
                key: _awayTeamKey,
                description: Strings.oppositionTeam,
                child: Selector<FirebaseViewModel, String>(
                  selector: (_, model) => model.entryFromId(id).opposition,
                  builder: (_, oppositionName, __) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      key: ValueKey<String>(oppositionName),
                      child: Text(
                        oppositionName,
                        textAlign: TextAlign.left,
                        style: TextStyles.form.copyWith(
                            color: Palette.dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  static Widget getNoDataText(String text) => Container(
        padding: EdgeInsets.only(top: 25),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 7.0),
              child: Icon(
                Icons.live_help,
                color: Palette.dark.withAlpha(200),
                size: 30.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyles.noData,
              ),
            ),
          ],
        ),
      );

  /// Returns a gigantic ugly example competition card for when the user
  /// enters the [CompetitionsPage] for the first time.
  static Widget exampleCompetition(
    BuildContext context,
    GlobalKey _titleKey,
    GlobalKey _dateKey,
    GlobalKey _scoreKey,
  ) {
    return ComplexCard(
        child: ListTile(
      trailing: Icon(Icons.keyboard_arrow_right, color: Palette.maroon),
      contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
      title: UIToolkit.showcase(
        context: context,
        key: _titleKey,
        description: Strings.competitionTitle,
        child: Text(DatabaseEntry.example.title,
            overflow: TextOverflow.ellipsis, maxLines: 2),
      ),
      subtitle: Row(children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 15.0),
          decoration: UIToolkit.rightSideBoxDecoration,
          child: UIToolkit.showcase(
              context: context,
              key: _dateKey,
              description: Strings.competitionDate,
              child: Text(DatabaseEntry.example.date,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyles.cardSubTitle)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: UIToolkit.showcase(
            context: context,
            key: _scoreKey,
            description: Strings.competitionScore,
            child: ComplexScore(DatabaseEntry.example.score),
          ),
        )
      ]),
    ));
  }

  /// Returns a big ugly example hole for when the user enters a
  /// [CompetitionPage] for the first time.
  static Widget exampleHole(
    BuildContext context,
    GlobalKey _holeKey,
    GlobalKey _playersKey,
    GlobalKey _holeHomeScoreKey,
    GlobalKey _holeAwayScoreKey,
    GlobalKey _holeNumberKey,
    GlobalKey _oppositionKey,
  ) {
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
