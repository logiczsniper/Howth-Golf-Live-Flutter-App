import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/style/palette.dart';

import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/competition_details/competition_details.dart';
import 'package:howth_golf_live/widgets/expanding_tiles/custom_expansion_tile.dart';
import 'package:howth_golf_live/widgets/expanding_tiles/icon_button_pair.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CompetitionPage extends StatelessWidget {
  final DatabaseEntry initialData;

  CompetitionPage(this.initialData);

  /// Get the styled and positioned widget to display the name of the player(s)
  /// for the designated [hole].
  Expanded _getPlayer(Hole hole, String text, int index, {bool away = false}) =>
      Expanded(
          child: Container(
              padding: EdgeInsets.all(17.5),
              alignment: away ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                  child: Text(text,
                      textAlign: away ? TextAlign.right : TextAlign.left,
                      style: TextStyles.cardSubTitle
                          .copyWith(color: Palette.darker)))));

  /// Gets the properly padded and styled score widget.
  Container _getScore(String text, {bool away = false}) => Container(
      child: Text(text,
          style: TextStyles.leadingChild
              .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
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
  Widget _rowBuilder(BuildContext context, Hole hole, String opposition,
          int index, int id) =>
      Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                /// Home team section.
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                      /// Home player.
                      _getPlayer(hole, hole.formattedPlayers, index),

                      /// Home score.
                      _getScore(hole.holeScore.howth)
                    ])),

                /// Hole Number
                UIToolkit.getHoleNumberDecorated(hole.holeNumber),

                /// Away team section.
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      /// Away team score.
                      _getScore(hole.holeScore.opposition, away: true),

                      /// Away team player.
                      _getPlayer(
                          hole, hole.formattedOpposition(opposition), index,
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
                target: ListView.builder(
                    padding: EdgeInsets.only(bottom: 100.0),
                    itemCount: currentData.holes.length +
                        _firebaseModel.bonusEntries(currentData, hasVisited),
                    itemBuilder: (context, index) {
                      if (index == 0)
                        return Padding(
                            padding: EdgeInsets.zero,
                            // padding: EdgeInsets.only(bottom: 12.5),
                            child: CompetitionDetails(
                                currentData,
                                _homeScoreKey,
                                _awayScoreKey,
                                _locationKey,
                                _dateKey,
                                _timeKey));
                      else if (index == 1)
                        return UIToolkit.getVersus(
                            context,
                            currentData.opposition,
                            Strings.homeAddress,
                            _homeTeamKey,
                            _awayTeamKey);
                      else if (!hasVisited && index == 2) {
                        return UIToolkit.exampleHole(
                            context,
                            _holeKey,
                            _playersKey,
                            _holeHomeScoreKey,
                            _holeAwayScoreKey,
                            _holeNumberKey,
                            _oppositionKey);
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

                        Hole currentHole = currentData.holes[index - 2];
                        int _index = holeIndex - 2;

                        return CustomExpansionTile(
                          key: ValueKey(currentHole),
                          title: Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: index % 2 != 0
                                      ? Palette.light
                                      : Palette.card.withAlpha(240),
                                  borderRadius: BorderRadius.circular(13.0)),
                              child: _rowBuilder(
                                  context,
                                  currentData.holes[_index],
                                  currentData.opposition,
                                  index,
                                  currentData.id)),
                          children: <Widget>[
                            _hasAccess
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      /// Modify howth's score!
                                      IconButtonPair(onAdd: () {
                                        Score updatedScore = currentHole
                                            .holeScore
                                            .updateScore(true, 1);
                                        Hole updatedHole = currentHole
                                            .updateHole(newScore: updatedScore);
                                        FirebaseInteration.of(context)
                                            .updateHole(_index, currentData.id,
                                                updatedHole);
                                      }, onSubtract: () {
                                        Score updatedScore = currentHole
                                            .holeScore
                                            .updateScore(true, -1);
                                        Hole updatedHole = currentHole
                                            .updateHole(newScore: updatedScore);
                                        FirebaseInteration.of(context)
                                            .updateHole(_index, currentData.id,
                                                updatedHole);
                                      }),

                                      /// Modify the hole number!
                                      IconButtonPair(
                                          iconColor: Palette.maroon,
                                          onAdd: () {
                                            Hole updatedHole =
                                                currentHole.updateNumber(1);
                                            FirebaseInteration.of(context)
                                                .updateHole(
                                                    _index,
                                                    currentData.id,
                                                    updatedHole);
                                          },
                                          onSubtract: () {
                                            Hole updatedHole =
                                                currentHole.updateNumber(-1);
                                            FirebaseInteration.of(context)
                                                .updateHole(
                                                    _index,
                                                    currentData.id,
                                                    updatedHole);
                                          }),

                                      /// Modify the opposition score!
                                      IconButtonPair(onAdd: () {
                                        Score updatedScore = currentHole
                                            .holeScore
                                            .updateScore(false, 1);
                                        Hole updatedHole = currentHole
                                            .updateHole(newScore: updatedScore);
                                        FirebaseInteration.of(context)
                                            .updateHole(_index, currentData.id,
                                                updatedHole);
                                      }, onSubtract: () {
                                        Score updatedScore = currentHole
                                            .holeScore
                                            .updateScore(false, -1);
                                        Hole updatedHole = currentHole
                                            .updateHole(newScore: updatedScore);
                                        FirebaseInteration.of(context)
                                            .updateHole(_index, currentData.id,
                                                updatedHole);
                                      }),
                                    ],
                                  )
                                : Container(),

                            /// Display the [lastUpdated] formatted.
                            Container(
                                padding: currentHole.comment.isEmpty
                                    ? EdgeInsets.only(bottom: 8.0)
                                    : null,
                                child: AnimatedSwitcher(
                                  child: Text(
                                      _firebaseModel.prettyLastUpdated(
                                          currentHole.lastUpdated),
                                      textAlign: TextAlign.center,
                                      style: TextStyles.cardTitle,
                                      key: ValueKey(DateTime.now())),
                                  duration: Duration(milliseconds: 350),
                                )),

                            /// If there is a [comment], display it.
                            currentHole.comment.isEmpty
                                ? Container()
                                : Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 6.0),
                                    child: Text(
                                      "Comment: ${currentHole.comment}",
                                      textAlign: TextAlign.center,
                                      style: TextStyles.cardTitle,
                                    ))
                          ],
                        );
                      }
                    }))));
  }
}
