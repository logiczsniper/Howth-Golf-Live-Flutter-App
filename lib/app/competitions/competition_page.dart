import 'package:flutter/material.dart';
import 'package:howth_golf_live/app/competitions/nested_auto_scroll.dart';

import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/app/hole_view_model.dart';
import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/competition_details/competition_details.dart';
import 'package:howth_golf_live/widgets/expanding_tiles/custom_expansion_tile.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CompetitionPage extends StatelessWidget {
  /// The [id] of the [DatabaseEntry] which this page is displaying.
  final int id;

  CompetitionPage(this.id);

  /// Get the styled and positioned widget to display the name of the player(s)
  /// for the designated [hole].
  Container _getPlayer(String text, {bool isOpposition = false}) => Container(
      padding: EdgeInsets.all(17.5),
      alignment: isOpposition ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          child: Text(text,
              textAlign: isOpposition ? TextAlign.right : TextAlign.left,
              style: TextStyles.cardSubTitle)));

  /// Gets the properly padded and styled score widget.
  Container _getScore(String text, {bool isOpposition = false}) => Container(
      child: Text(text,
          style: TextStyles.leadingChild.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
      padding:
          EdgeInsets.fromLTRB(isOpposition ? 12.0 : 16.0, 3.0, !isOpposition ? 12.0 : 16.0, 3.0));

  /// Builds the [Column] of data at the top of the competition.
  ///
  /// This includes:
  ///   - the 'finished' banner if the competition is archived
  ///   - the [CompetitionDetails]
  ///   - the 'versus' widget.
  Widget _columnBuilder(
      BuildContext context,
      GlobalKey _howthScoreKey,
      GlobalKey _oppositionScoreKey,
      GlobalKey _oppositionTeamKey,
      GlobalKey _locationKey,
      GlobalKey _dateKey,
      GlobalKey _timeKey) {
    return Column(
      children: <Widget>[
        Selector<FirebaseViewModel, bool>(
          selector: (_, model) => model.entryFromId(id).isArchived,
          builder: (_, isArchived, banner) => isArchived ? banner : Container(),
          child: OpacityChangeWidget(
            target: Container(
                padding: EdgeInsets.all(6.0),
                margin: EdgeInsets.fromLTRB(26.0, 10.0, 26.0, 0.0),
                width: 200,
                decoration:
                    BoxDecoration(color: Palette.maroon, borderRadius: BorderRadius.circular(13.0)),
                child: Text(
                  Strings.finished,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Palette.inMaroon, fontWeight: FontWeight.w600),
                )),
          ),
        ),
        CompetitionDetails(
          id,
          _howthScoreKey,
          _oppositionScoreKey,
          _locationKey,
          _dateKey,
          _timeKey,
        ),
        UIToolkit.getVersus(context, id, _oppositionTeamKey)
      ],
    );
  }

  /// Constructs a single row in the table of holes.
  ///
  /// This row contains details of one [Hole] as given by [hole].
  /// Depending on [isHome], howth's information will be on the
  /// right or the left.
  ///
  /// The [index] is the index of the [hole] within [currentData], which must be known
  /// when navigating to the individual hole page so that the user can update a single hole-
  /// the hole specified by the index.
  Widget _rowBuilder(BuildContext context, int index, int id) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            /// Howth team section.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  /// Howth player.
                  Expanded(
                    child: Selector<FirebaseViewModel, String>(
                      selector: (_, model) => model.holeFromIndex(id, index).formattedPlayers,
                      builder: (_, homePlayers, child) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Container(
                          key: ValueKey<String>(homePlayers),
                          child: _getPlayer(homePlayers),
                        ),
                      ),
                    ),
                  ),

                  /// Howth score.
                  Selector<FirebaseViewModel, String>(
                    selector: (_, model) => model.holeFromIndex(id, index).holeScore.howth,
                    builder: (_, howthScoreString, __) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Container(
                        key: ValueKey<String>(howthScoreString),
                        child: _getScore(howthScoreString),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Hole Number
            Selector<FirebaseViewModel, int>(
              selector: (_, model) => model.holeFromIndex(id, index).holeNumber,
              builder: (_, holeNumber, __) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Container(
                  key: ValueKey<int>(holeNumber),
                  child: UIToolkit.getHoleNumberDecorated(holeNumber),
                ),
              ),
            ),

            /// Opposition team section.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  /// Opposition team score.
                  Selector<FirebaseViewModel, String>(
                    selector: (_, model) => model.holeFromIndex(id, index).holeScore.opposition,
                    builder: (_, oppositionScoreString, __) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Container(
                        key: ValueKey<String>(oppositionScoreString),
                        child: _getScore(oppositionScoreString, isOpposition: true),
                      ),
                    ),
                  ),

                  /// Opposition team player / club.
                  /// Rebuild if the opposition club name changes
                  Expanded(
                    child: Selector<FirebaseViewModel, String>(
                      selector: (_, model) => model
                          .holeFromIndex(id, index)
                          .formattedOpposition(model.entryFromId(id).opposition),
                      builder: (_, oppositionString, __) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Container(
                          key: ValueKey<String>(oppositionString),
                          child: _getPlayer(oppositionString, isOpposition: true),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    /// We must listen actively to the [UserStatusViewModel].
    var _userStatus = Provider.of<UserStatusViewModel>(context);

    /// All hole data is monitored via [Selector] or [Consumer] widgets.
    var _holeModel = Provider.of<HoleViewModel>(context, listen: false);

    /// The single controller being used in all the competition pages.
    final ScrollController _scrollController = ScrollController();

    _scrollController.addListener(() {
      _holeModel.scroll(id, _scrollController.offset);
    });

    /// The keys for the showcase.
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

    /// If the user has not visited this page before, play the showcase.
    ///
    /// In [Routes], the route is visited automatically after the showcase
    /// ends.
    bool hasVisited = _userStatus.hasVisited(Strings.specificCompetition);
    if (!hasVisited) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(
          const Duration(milliseconds: 650),
          () => ShowCaseWidget.of(context).startShowCase(keys),
        ),
      );
    }

    /// Creates a FAB which rebuilds using [Selector].
    ///
    /// If the user does not [hasAccess] then the button is
    /// replaced by a [Container] which isnt visible.
    Widget floatingActionButton = Selector2<UserStatusViewModel, FirebaseViewModel, bool>(
        selector: (context, userStatusModel, firebaseModel) {
          DatabaseEntry entry = firebaseModel.entryFromId(id);

          /// If [entry] is the [DatabaseEntry.empty], that means it was deleted and
          /// this page must be popped from the navigation stack.
          ///
          /// Using [popUntil] in case a modal is over the page (add players modal).
          if (entry.id == -2) {
            Routes.of(context).popToCompetitions();
            return false;
          }

          return firebaseModel.entryFromId(id).isArchived
              ? userStatusModel.isAdmin
              : userStatusModel.isManager(id);
        },
        builder: (context, hasAccess, child) => hasAccess
            ? UIToolkit.createButton(
                context: context,
                primaryText: Strings.newHole,
                secondaryText: Strings.tapEditHole,
                id: id)
            : Container());

    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 10.0),
        child: floatingActionButton,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body:

          /// If the [itemCount] changes, the hole list view must update
          /// in this [Selector].
          SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, _) => <Widget>[
            CodeFieldBar(
              Strings.specificCompetition,
              _userStatus,
              _backKey,
              _codeKey,
              id: id,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(180.0),
                child: _columnBuilder(
                  context,
                  _howthScoreKey,
                  _oppositionScoreKey,
                  _oppositionTeamKey,
                  _locationKey,
                  _dateKey,
                  _timeKey,
                ),
              ),
            ),
          ],
          body: Selector<FirebaseViewModel, Tuple2<int, bool>>(
            selector: (_, model) => Tuple2(
              model.holesItemCount(id, hasVisited),
              model.entryFromId(id).holes.isEmpty,
            ),

            /// The [data] parameter is the [Tuple2] created above.
            ///
            /// [data.item1] is the [itemCount], while
            /// [data.item2] is whether the current competition has any holes.
            ///
            /// [child] is the [_columnBuilder] result.
            builder: (context, data, child) {
              final ScrollController _innerScrollController = PrimaryScrollController.of(context);

              /// Listen to the [_innerScrollController], saving the scroll position in
              /// [HoleDataViewModel].
              _innerScrollController.addListener(() {
                _holeModel.scrollInner(id, _innerScrollController.offset);
              });

              /// Scroll to the current position as stored in [_holeModel].
              ///
              /// This adds the feature of saving your scroll position for
              /// each competition page.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollController.jumpTo(_holeModel.offset(id: id));
                double _innerOffset = _holeModel.innerOffset(id: id);
                if (_innerOffset > 0) {
                  _innerScrollController.jumpTo(_innerOffset);
                }
              });

              /// My own [NestedAutoScroller] object which is later used
              /// to complete the autoscroll functionality when a row is
              /// tapped.
              final autoScroller = NestedAutoScroller(
                scrollController: _scrollController,
                innerScrollController: _innerScrollController,
                averageItemExtent: 70.0,
                threshold: 145.0,
              );

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                child: ListView.builder(
                  key: ValueKey<int>(data.item2 ? data.item1 - 1 : data.item1),
                  padding: EdgeInsets.only(bottom: 400),
                  itemCount: data.item1,
                  itemBuilder: (context, index) {
                    /// The archived banner (if archived), [CompetitionDetails], and [UIToolkit.getVersus]
                    /// widgets in one column.
                    if (index == 0) {
                      if (!hasVisited)
                        return UIToolkit.exampleHole(
                            context,
                            _holeKey,
                            _playersKey,
                            _holeHowthScoreKey,
                            _holeOppositionScoreKey,
                            _holeNumberKey,
                            _oppositionKey);
                      else if (data.item2) return UIToolkit.getNoDataText(Strings.noHoles);
                    }

                    /// If there are no more special conditions to handle, proceed with hole list creation.
                    int _index = index;

                    /// If the page has not been visted before, subtract one from the [_index] to
                    /// account for the [UIToolkit.exampleHole].
                    if (!hasVisited) _index--;

                    return Consumer<HoleViewModel>(
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          child: _rowBuilder(context, _index, id),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13.0),
                              color: index % 2 != 0 ? Palette.light : Palette.card.withAlpha(240))),
                      builder: (context, model, child) => CustomExpansionTile(
                        title: child,
                        id: id,
                        index: _index,
                        initiallyExpanded: model.openIndices(id: id).contains(_index),
                        onExpansionChanged: (bool isOpen) {
                          if (isOpen) {
                            model.open(id, _index);
                            autoScroller.animateTo(_index);
                          } else {
                            model.close(id, _index);
                          }
                        },
                        children: <Widget>[
                          /// Display the [lastUpdated] formatted.
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            child: Selector<FirebaseViewModel, String>(
                              selector: (_, model) =>
                                  model.holeFromIndex(id, index).prettyLastUpdated,
                              builder: (_, lastUpdatedPretty, __) => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                child: Text(
                                  lastUpdatedPretty,
                                  key: ValueKey<String>(lastUpdatedPretty),
                                  textAlign: TextAlign.center,
                                  style: TextStyles.cardTitle,
                                ),
                              ),
                            ),
                          ),

                          /// If there is a [comment], display it.
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 27.0),
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            child: Selector<FirebaseViewModel, String>(
                              selector: (_, model) => model.holeFromIndex(id, index).comment,
                              builder: (_, comment, __) => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                child: comment.isEmpty
                                    ? Container()
                                    : Text(
                                        "Comment: $comment",
                                        key: ValueKey<String>(comment),
                                        textAlign: TextAlign.center,
                                        style: TextStyles.cardTitle,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
