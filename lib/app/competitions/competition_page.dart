import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/app/hole_view_model.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
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
  Expanded _getPlayer(Hole hole, String text, int index,
          {bool isOpposition = false}) =>
      Expanded(
          child: Container(
              padding: EdgeInsets.all(17.5),
              alignment:
                  isOpposition ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                  child: Text(text,
                      textAlign:
                          isOpposition ? TextAlign.right : TextAlign.left,
                      style: TextStyles.cardSubTitle))));

  /// Gets the properly padded and styled score widget.
  Container _getScore(String text, {bool isOpposition = false}) => Container(
      child: Text(text,
          style: TextStyles.leadingChild
              .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
      padding: EdgeInsets.fromLTRB(
          isOpposition ? 12.0 : 16.0, 3.0, !isOpposition ? 12.0 : 16.0, 3.0));

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
                      _getScore(hole.holeScore.opposition, isOpposition: true),

                      /// Away team player.
                      _getPlayer(
                          hole, hole.formattedOpposition(opposition), index,
                          isOpposition: true)
                    ]))
              ]));

  @override
  Widget build(BuildContext context) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);
    var _firebaseModel = Provider.of<FirebaseViewModel>(context);
    var _holeModel = Provider.of<HoleViewModel>(context, listen: false);

    final ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      _holeModel.scroll(_scrollController.offset);
    });

    DatabaseEntry currentData =
        _firebaseModel.entryFromId(initialData.id) ?? initialData;

    /// The user has access to modify this competition if they are an admin or they are a manager and
    /// this competition is NOT archived.
    bool _hasAccess = _firebaseModel.isArchived(currentData)
        ? _userStatus.isAdmin
        : _userStatus.isManager(currentData.id);

    Widget floatingActionButton = _hasAccess
        ? UIToolkit.createButton(
            context: context,
            primaryText: Strings.newHole,
            secondaryText: Strings.tapEditHole,
            id: currentData.id)
        : null;

    final GlobalKey _howthScoreKey = GlobalKey();
    final GlobalKey _oppositionScoreKey = GlobalKey();
    final GlobalKey _locationKey = GlobalKey();
    final GlobalKey _dateKey = GlobalKey();
    final GlobalKey _timeKey = GlobalKey();
    final GlobalKey _oppositionTeamKey = GlobalKey();
    final GlobalKey _holeKey = GlobalKey();
    final GlobalKey _playersKey = GlobalKey();
    final GlobalKey _oppositionKey = GlobalKey();
    final GlobalKey _holeNumberKey = GlobalKey();
    final GlobalKey _holeHowthScoreKey = GlobalKey();
    final GlobalKey _holeOppositionScoreKey = GlobalKey();
    final GlobalKey _backKey = GlobalKey();
    final GlobalKey _codeKey = GlobalKey();

    List<GlobalKey> keys = [
      _howthScoreKey,
      _oppositionScoreKey,
      _locationKey,
      _dateKey,
      _timeKey,
      _oppositionTeamKey,
      _holeKey,
      _playersKey,
      _oppositionKey,
      _holeHowthScoreKey,
      _holeNumberKey,
      _holeOppositionScoreKey,
      _backKey,
      _codeKey
    ];

    bool hasVisited = _userStatus.hasVisited(Strings.specificCompetition);

    if (!hasVisited) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase(keys));
    }

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.jumpTo(_holeModel.offset));

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
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: 200.0),
                    itemCount: currentData.holes.length +
                        _firebaseModel.bonusEntries(currentData, hasVisited),
                    itemBuilder: (context, index) {
                      if (index == 0 && _firebaseModel.isArchived(currentData))
                        return Container(
                            padding: EdgeInsets.all(6.0),
                            margin: EdgeInsets.fromLTRB(26.0, 10.0, 26.0, 0.0),
                            decoration: BoxDecoration(
                                color: Palette.maroon,
                                borderRadius: BorderRadius.circular(13.0)),
                            child: Text(
                              Strings.finished,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Palette.inMaroon,
                                  fontWeight: FontWeight.w600),
                            ));
                      else if (index == 0 ||
                          index == 1 && _firebaseModel.isArchived(currentData))
                        return Padding(
                            padding: EdgeInsets.zero,
                            child: CompetitionDetails(
                                currentData,
                                _howthScoreKey,
                                _oppositionScoreKey,
                                _locationKey,
                                _dateKey,
                                _timeKey));
                      else if (index == 1 ||
                          index == 2 && _firebaseModel.isArchived(currentData))
                        return UIToolkit.getVersus(
                            context,
                            currentData.opposition,
                            Strings.homeAddress,
                            _oppositionTeamKey);
                      else if (!hasVisited && index == 2 ||
                          !hasVisited &&
                              index == 3 &&
                              _firebaseModel.isArchived(currentData)) {
                        return UIToolkit.exampleHole(
                            context,
                            _holeKey,
                            _playersKey,
                            _holeHowthScoreKey,
                            _holeOppositionScoreKey,
                            _holeNumberKey,
                            _oppositionKey);
                      } else if (currentData.holes.isEmpty) {
                        return Container(
                            padding: EdgeInsets.only(top: 25),
                            alignment: Alignment.center,
                            child: Column(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(bottom: 7.0),
                                  child: Icon(Icons.live_help,
                                      color: Palette.dark.withAlpha(200),
                                      size: 30.0)),
                              Padding(
                                  child: Text(
                                      Strings.noHoles + currentData.title + "!",
                                      textAlign: TextAlign.center,
                                      style: TextStyles.noData),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0)),
                            ]));
                      } else {
                        int holeIndex = index;
                        if (!hasVisited) holeIndex--;
                        if (_firebaseModel.isArchived(currentData)) holeIndex--;

                        int _index = holeIndex - 2;
                        Hole currentHole = currentData.holes[_index];

                        return Consumer<HoleViewModel>(
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: index % 2 !=
                                            (_firebaseModel
                                                    .isArchived(currentData)
                                                ? 1
                                                : 0)
                                        ? Palette.light
                                        : Palette.card.withAlpha(240),
                                    borderRadius: BorderRadius.circular(13.0)),
                                child: _rowBuilder(
                                    context,
                                    currentData.holes[_index],
                                    currentData.opposition,
                                    index,
                                    currentData.id)),
                            builder: (context, model, child) =>
                                CustomExpansionTile(
                                  key: ValueKey(currentHole),
                                  initiallyExpanded: _index == model.openIndex,
                                  onExpansionChanged: (bool isOpen) {
                                    if (isOpen) {
                                      model.open(_index);
                                      double _offset =
                                          (_index * 60 + 60).toDouble();

                                      /// If the difference between the current position and where the
                                      /// scroll would end up is too great, scroll!
                                      if ((_scrollController.offset - _offset)
                                              .abs() >
                                          60)
                                        _scrollController.animateTo(_offset,
                                            duration:
                                                Duration(milliseconds: 700),
                                            curve: Curves.easeInOutQuart);
                                    } else {
                                      model.close();
                                    }
                                  },
                                  title: child,
                                  children: <Widget>[
                                    _hasAccess
                                        ? Stack(
                                            children: <Widget>[
                                              /// Modify/delete the hole!
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 26.0),
                                                padding: EdgeInsets.only(
                                                    bottom: 4.0,
                                                    left: 0.5,
                                                    right: 0.5),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                          onTap: () =>
                                                              Routes.of(context)
                                                                  .toHoleModification(
                                                                currentData.id,
                                                                _index,
                                                                currentHole,
                                                                currentData
                                                                    .opposition,
                                                              ),
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: 32.0,
                                                          )),
                                                      GestureDetector(
                                                          onTap: () => showModal(
                                                              context: context,
                                                              configuration:
                                                                  FadeScaleTransitionConfiguration(),
                                                              builder: (context) => CustomAlertDialog(
                                                                  FirebaseInteraction.of(
                                                                          context)
                                                                      .deleteHole,
                                                                  index: _index,
                                                                  id: currentData
                                                                      .id)),
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 32.0,
                                                          )),
                                                    ]),
                                              ),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  /// Modify howth's score!
                                                  IconButtonPair(onAdd: () {
                                                    Score updatedScore =
                                                        currentHole.holeScore
                                                            .updateScore(
                                                                true, 1);
                                                    Hole updatedHole =
                                                        currentHole.updateHole(
                                                            newScore:
                                                                updatedScore);
                                                    FirebaseInteraction.of(
                                                            context)
                                                        .updateHole(
                                                            _index,
                                                            currentData.id,
                                                            updatedHole);
                                                  }, onSubtract: () {
                                                    Score updatedScore =
                                                        currentHole.holeScore
                                                            .updateScore(
                                                                true, -1);
                                                    Hole updatedHole =
                                                        currentHole.updateHole(
                                                            newScore:
                                                                updatedScore);
                                                    FirebaseInteraction.of(
                                                            context)
                                                        .updateHole(
                                                            _index,
                                                            currentData.id,
                                                            updatedHole);
                                                  }),

                                                  /// Modify the hole number!
                                                  IconButtonPair(
                                                      iconColor: Palette.maroon,
                                                      onAdd: () {
                                                        Hole updatedHole =
                                                            currentHole
                                                                .updateNumber(
                                                                    1);
                                                        FirebaseInteraction.of(
                                                                context)
                                                            .updateHole(
                                                                _index,
                                                                currentData.id,
                                                                updatedHole);
                                                      },
                                                      onSubtract: () {
                                                        Hole updatedHole =
                                                            currentHole
                                                                .updateNumber(
                                                                    -1);
                                                        FirebaseInteraction.of(
                                                                context)
                                                            .updateHole(
                                                                _index,
                                                                currentData.id,
                                                                updatedHole);
                                                      }),

                                                  /// Modify the opposition score!
                                                  IconButtonPair(onAdd: () {
                                                    Score updatedScore =
                                                        currentHole.holeScore
                                                            .updateScore(
                                                                false, 1);
                                                    Hole updatedHole =
                                                        currentHole.updateHole(
                                                            newScore:
                                                                updatedScore);
                                                    FirebaseInteraction.of(
                                                            context)
                                                        .updateHole(
                                                            _index,
                                                            currentData.id,
                                                            updatedHole);
                                                  }, onSubtract: () {
                                                    Score updatedScore =
                                                        currentHole
                                                            .holeScore
                                                            .updateScore(
                                                                false, -1);
                                                    Hole updatedHole =
                                                        currentHole.updateHole(
                                                            newScore:
                                                                updatedScore);
                                                    FirebaseInteraction.of(
                                                            context)
                                                        .updateHole(
                                                            _index,
                                                            currentData.id,
                                                            updatedHole);
                                                  }),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Container(),

                                    /// Display the [lastUpdated] formatted.
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3.0),
                                      padding: currentHole.comment.isEmpty
                                          ? EdgeInsets.only(bottom: 8.0)
                                          : null,
                                      child: Text(
                                        _firebaseModel.prettyLastUpdated(
                                            currentHole.lastUpdated),
                                        textAlign: TextAlign.center,
                                        style: TextStyles.cardTitle,
                                      ),
                                    ),

                                    /// If there is a [comment], display it.
                                    currentHole.comment.isEmpty
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 3.0),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Text(
                                              "Comment: ${currentHole.comment}",
                                              textAlign: TextAlign.center,
                                              style: TextStyles.cardTitle,
                                            ))
                                  ],
                                ));
                      }
                    }))));
  }
}
