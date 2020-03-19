import 'package:flutter/material.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/style/palette.dart';

import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/competition_details/competition_details.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:showcaseview/showcase_widget.dart';

class CompetitionPage extends StatelessWidget {
  final DatabaseEntry initialData;

  CompetitionPage(this.initialData);

  /// Get the styled and positioned widget to display the name of the player(s)
  /// for the designated [hole].
  Expanded _getPlayer(Hole hole, String text, int index, {bool away = false}) =>
      Expanded(
          child: Align(
              alignment: away ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: index % 2 != 0
                          ? Palette.light
                          : Palette.card.withAlpha(240),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: Text(text,
                      textAlign: away ? TextAlign.right : TextAlign.left,
                      style: TextStyles.cardSubTitle))));

  /// Gets the properly padded and styled score widget.
  Container _getScore(String text, {bool away = false}) => Container(
      child: Text(text, style: TextStyles.leadingChild),
      padding: EdgeInsets.fromLTRB(
          away ? 12.0 : 16.0, 3.0, !away ? 12.0 : 16.0, 3.0));

  /// Constructs a single row in the table of holes.
  ///
  /// This row contains details of one [Hole] as given by [hole].
  /// Depending on [isHome], howth's information will be on the
  /// right or the left.
  ///
  /// The [index] is the index of the [hole] within [currentData], which must be known
  /// when navigating to the individual hole page so that the user can update a single hole-
  /// the hole specified by the index.
  Widget _rowBuilder(BuildContext context, Hole hole, bool isHome,
          String opposition, int index, int id) =>
      Padding(
          padding: EdgeInsets.all(5.3),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                /// Home team section.
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                      /// Home player.
                      _getPlayer(
                          hole,
                          isHome
                              ? hole.formattedPlayers
                              : hole.formattedOpposition(opposition),
                          index),

                      /// Home score.
                      _getScore(isHome
                          ? hole.holeScore.howth
                          : hole.holeScore.opposition)
                    ])),

                /// Hole Number
                UIToolkit.getHoleNumberDecorated(hole.holeNumber),

                /// Away team section.
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      /// Away team score.
                      _getScore(
                          !isHome
                              ? hole.holeScore.howth
                              : hole.holeScore.opposition,
                          away: true),

                      /// Away team player.
                      _getPlayer(
                          hole,
                          !isHome
                              ? hole.formattedPlayers
                              : hole.formattedOpposition(opposition),
                          index,
                          away: true)
                    ]))
              ]));

  @override
  Widget build(BuildContext context) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);
    var _firebaseModel = Provider.of<FirebaseViewModel>(context);

    DatabaseEntry currentData =
        _firebaseModel.entryFromId(initialData.id) ?? initialData;
    bool _hasAccess = _userStatus.isManager(currentData.id);

    Widget floatingActionButton = _hasAccess
        ? UIToolkit.createButton(
            context: context, text: Strings.newHole, id: currentData.id)
        : null;

    final GlobalKey _homeScoreKey = GlobalKey();
    final GlobalKey _awayScoreKey = GlobalKey();
    final GlobalKey _locationKey = GlobalKey();
    final GlobalKey _dateKey = GlobalKey();
    final GlobalKey _timeKey = GlobalKey();
    final GlobalKey _homeTeamKey = GlobalKey();
    final GlobalKey _awayTeamKey = GlobalKey();
    final GlobalKey _holeKey = GlobalKey();
    final GlobalKey _playersKey = GlobalKey();
    final GlobalKey _oppositionKey = GlobalKey();
    final GlobalKey _holeNumberKey = GlobalKey();
    final GlobalKey _holeHomeScoreKey = GlobalKey();
    final GlobalKey _holeAwayScoreKey = GlobalKey();
    final GlobalKey _backKey = GlobalKey();
    final GlobalKey _codeKey = GlobalKey();

    List<GlobalKey> keys = [
      _homeScoreKey,
      _awayScoreKey,
      _locationKey,
      _dateKey,
      _timeKey,
      _homeTeamKey,
      _awayTeamKey,
      _holeKey,
      _playersKey,
      _oppositionKey,
      _holeHomeScoreKey,
      _holeNumberKey,
      _holeAwayScoreKey,
      _backKey,
      _codeKey
    ];

    bool hasVisited = _userStatus.hasVisited(Strings.specificCompetition);

    if (!hasVisited) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase(keys));
    }

    return Scaffold(
        floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: floatingActionButton),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: CodeFieldBar(currentData.title, _userStatus, _backKey, _codeKey,
            id: currentData.id),
        body: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            child: OpacityChangeWidget(
                key: ValueKey(DateTime.now()),
                target: ListView.separated(
                    padding: EdgeInsets.only(bottom: 100.0),
                    itemCount: currentData.holes.length +
                        _firebaseModel.bonusEntries(currentData, hasVisited),
                    separatorBuilder: (context, index) {
                      if (index != 0 && index != 1)
                        return Divider();
                      else
                        return Container();
                    },
                    itemBuilder: (context, index) {
                      if (index == 0)
                        return CompetitionDetails(currentData, _homeScoreKey,
                            _awayScoreKey, _locationKey, _dateKey, _timeKey);
                      else if (index == 1)
                        return UIToolkit.getVersus(
                            context,
                            currentData.location.isHome,
                            currentData.opposition,
                            Strings.homeAddress,
                            _homeTeamKey,
                            _awayTeamKey);
                      else if (!hasVisited && index == 2) {
                        Hole hole = Hole.example;
                        bool isHome = currentData.location.isHome;
                        return UIToolkit.showcase(
                            context: context,
                            key: _holeKey,
                            description: Strings.hole,
                            child: Padding(
                                padding: EdgeInsets.all(5.3),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      /// Home team section.
                                      Expanded(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                            /// Home player.
                                            Expanded(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: UIToolkit.showcase(
                                                        context: context,
                                                        key: _playersKey,
                                                        description:
                                                            Strings.players,
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            decoration: BoxDecoration(
                                                                color: Palette
                                                                    .card
                                                                    .withAlpha(
                                                                        240),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        13.0)),
                                                            child: Text(
                                                                "Home player(s)/club",
                                                                textAlign:
                                                                    TextAlign.left,
                                                                style: TextStyles.cardSubTitle))))),

                                            /// Home score.
                                            UIToolkit.showcase(
                                                context: context,
                                                key: _holeHomeScoreKey,
                                                description:
                                                    Strings.holeHomeScore,
                                                child: Container(
                                                    child: Text(
                                                        isHome
                                                            ? hole
                                                                .holeScore.howth
                                                            : hole.holeScore
                                                                .opposition,
                                                        style: TextStyles
                                                            .leadingChild),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            16.0,
                                                            3.0,
                                                            12.0,
                                                            3.0))),
                                          ])),

                                      /// Hole Number
                                      UIToolkit.showcase(
                                          context: context,
                                          key: _holeNumberKey,
                                          description: Strings.holeNumber,
                                          child:
                                              UIToolkit.getHoleNumberDecorated(
                                                  hole.holeNumber)),

                                      /// Away team section.
                                      Expanded(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                            /// Away team score.
                                            UIToolkit.showcase(
                                                context: context,
                                                key: _holeAwayScoreKey,
                                                description:
                                                    Strings.holeAwayScore,
                                                child: Container(
                                                    child: Text(
                                                        !isHome
                                                            ? hole
                                                                .holeScore.howth
                                                            : hole.holeScore
                                                                .opposition,
                                                        style: TextStyles
                                                            .leadingChild),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            12.0,
                                                            3.0,
                                                            16.0,
                                                            3.0))),

                                            /// Away team player.
                                            Expanded(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: UIToolkit.showcase(
                                                        context: context,
                                                        key: _oppositionKey,
                                                        description:
                                                            Strings.opposition,
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            decoration: BoxDecoration(
                                                                color: Palette.card
                                                                    .withAlpha(
                                                                        240),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        13.0)),
                                                            child: Text(
                                                                "Away player(s)/club",
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: TextStyles.cardSubTitle))))),
                                          ]))
                                    ])));
                      } else if (currentData.holes.isEmpty)
                        return Center(
                            child: Padding(
                                child: Text(
                                    Strings.noHoles + currentData.title + "!",
                                    textAlign: TextAlign.center,
                                    style: TextStyles.noData),
                                padding: EdgeInsets.only(top: 25.0)));
                      else {
                        int holeIndex = index;

                        if (!hasVisited) holeIndex--;

                        return GestureDetector(
                            onTap: () => Routes.of(context)
                                .toHole(currentData.id, holeIndex - 2),
                            child: Container(
                                child: _rowBuilder(
                                    context,
                                    currentData.holes[holeIndex - 2],
                                    currentData.location.isHome,
                                    currentData.opposition,
                                    index,
                                    currentData.id)));
                      }
                    }))));
  }
}
