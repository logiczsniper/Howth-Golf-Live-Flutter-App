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
import 'package:tuple/tuple.dart';

class CompetitionPage extends StatelessWidget {
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
          style: TextStyles.leadingChild
              .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
      padding: EdgeInsets.fromLTRB(
          isOpposition ? 12.0 : 16.0, 3.0, !isOpposition ? 12.0 : 16.0, 3.0));

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
                decoration: BoxDecoration(
                    color: Palette.maroon,
                    borderRadius: BorderRadius.circular(13.0)),
                child: Text(
                  Strings.finished,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Palette.inMaroon, fontWeight: FontWeight.w600),
                )),
          ),
        ),
        Padding(
            padding: EdgeInsets.zero,
            child: CompetitionDetails(id, _howthScoreKey, _oppositionScoreKey,
                _locationKey, _dateKey, _timeKey)),
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
            /// Home team section.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  /// Home player.
                  Expanded(
                    child: Selector<FirebaseViewModel, String>(
                      selector: (_, model) => model
                          .entryFromId(id)
                          .holes
                          .elementAt(index)
                          .formattedPlayers,
                      builder: (_, homePlayers, child) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Container(
                          key: ValueKey<String>(homePlayers),
                          child: _getPlayer(homePlayers),
                        ),
                      ),
                    ),
                  ),

                  /// Home score.
                  Selector<FirebaseViewModel, String>(
                    selector: (_, model) => model
                        .entryFromId(id)
                        .holes
                        .elementAt(index)
                        .holeScore
                        .howth,
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
              selector: (_, model) =>
                  model.entryFromId(id).holes.elementAt(index).holeNumber,
              builder: (_, holeNumber, __) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Container(
                  key: ValueKey<int>(holeNumber),
                  child: UIToolkit.getHoleNumberDecorated(holeNumber),
                ),
              ),
            ),

            /// Away team section.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  /// Away team score.
                  Selector<FirebaseViewModel, String>(
                    selector: (_, model) => model
                        .entryFromId(id)
                        .holes
                        .elementAt(index)
                        .holeScore
                        .opposition,
                    builder: (_, oppositionScoreString, __) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Container(
                        key: ValueKey<String>(oppositionScoreString),
                        child: _getScore(oppositionScoreString,
                            isOpposition: true),
                      ),
                    ),
                  ),

                  /// Away team player / club.
                  /// Rebuild if the opposition club name changes
                  Expanded(
                    child: Selector<FirebaseViewModel, String>(
                      selector: (_, model) => model
                          .entryFromId(id)
                          .holes
                          .elementAt(index)
                          .formattedOpposition(
                              model.entryFromId(id).opposition),
                      builder: (_, oppositionString, __) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Container(
                          key: ValueKey<String>(oppositionString),
                          child:
                              _getPlayer(oppositionString, isOpposition: true),
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
    var _userStatus = Provider.of<UserStatusViewModel>(context);
    var _holeModel = Provider.of<HoleViewModel>(context, listen: false);

    final ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      _holeModel.scroll(_scrollController.offset);
    });

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

    Widget floatingActionButton =
        Selector2<UserStatusViewModel, FirebaseViewModel, bool>(
            selector: (context, userStatusModel, firebaseModel) =>
                firebaseModel.entryFromId(id).isArchived
                    ? userStatusModel.isAdmin
                    : userStatusModel.isManager(id),
            builder: (context, hasAccess, child) => hasAccess
                ? UIToolkit.createButton(
                    context: context,
                    primaryText: Strings.newHole,
                    secondaryText: Strings.tapEditHole,
                    id: id)
                : Container());

    return Scaffold(
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: CodeFieldBar(
          Strings.specificCompetition, _userStatus, _backKey, _codeKey,
          id: id),
      body:

          /// If the [itemCount] changes, the hole list view must update
          /// in this [Selector].
          Selector<FirebaseViewModel, Tuple2<int, bool>>(
        child: _columnBuilder(
          context,
          _howthScoreKey,
          _oppositionScoreKey,
          _oppositionTeamKey,
          _locationKey,
          _dateKey,
          _timeKey,
        ),
        selector: (_, model) => Tuple2(
          model.holesItemCount(id, hasVisited),
          model.entryFromId(id).holes.isEmpty,
        ),
        builder: (_, data, child) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: 400.0),
            shrinkWrap: true,
            itemCount: data.item1,
            itemBuilder: (context, index) {
              if (index == 0)

                /// The archived banner (if archived), [CompetitionDetails], and [UIToolkit.getVersus]
                /// widgets in one column.
                return child;
              else if (index == 1) {
                if (!hasVisited)
                  return UIToolkit.exampleHole(
                      context,
                      _holeKey,
                      _playersKey,
                      _holeHowthScoreKey,
                      _holeOppositionScoreKey,
                      _holeNumberKey,
                      _oppositionKey);
                else if (data.item2)
                  return UIToolkit.getNoDataText(Strings.noHoles);
              }

              /// If there are no more special conditions to handle, proceed with hole list creation.
              /// Subtract one from the [index] to account for the [columnBuilder].
              int _index = --index;

              /// If the page has not been visted before, subtract one from the [_index] to
              /// account for the [UIToolkit.exampleHole].
              if (!hasVisited) _index--;

              /// Create a controller which will be passed into the state of [CustomExpansionTile]
              /// which enables us to call the [ExpansionTile._handleTap] method from here.
              CustomExpansionTileController customExpansionTileController =
                  CustomExpansionTileController();

              return Consumer<HoleViewModel>(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: _rowBuilder(context, _index, id),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: index % 2 != 0
                            ? Palette.light
                            : Palette.card.withAlpha(240))),
                builder: (context, model, child) => CustomExpansionTile(
                  customExpansionTileController: customExpansionTileController,
                  title: child,
                  initiallyExpanded: _index == model.openIndex,
                  onExpansionChanged: (bool isOpen) {
                    if (isOpen) {
                      model.open(_index);
                      double _offset = (_index * 60 + 50).toDouble();

                      /// If the difference between the current position and where the
                      /// scroll would end up is too great, scroll!
                      if ((_scrollController.offset - _offset).abs() > 60)
                        _scrollController.animateTo(_offset,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInOutQuart);
                    } else {
                      model.close();
                    }
                  },
                  children: <Widget>[
                    Selector2<UserStatusViewModel, FirebaseViewModel, bool>(
                      selector: (context, userStatusModel, firebaseModel) =>
                          firebaseModel.entryFromId(id).isArchived
                              ? userStatusModel.isAdmin
                              : userStatusModel.isManager(id),
                      builder: (context, hasAccess, child) => hasAccess
                          ? Stack(
                              children: <Widget>[
                                /// Done button!
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 28.0),
                                    // decoration: UIToolkit
                                    //     .roundedRectBoxDecoration
                                    //     .copyWith(color: Palette.dark),
                                    child: GestureDetector(
                                      onTap: () {
                                        model.close();
                                        customExpansionTileController.tap();
                                      },
                                      child: Icon(Icons.publish, size: 35.0),

                                      // child: Text(
                                      //   "Done",
                                      //   textAlign: TextAlign.end,
                                      //   style: TextStyles.cardSubTitle.copyWith(
                                      //     color: Palette.inMaroon,
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),

                                /// Modify/delete the hole!
                                Container(
                                  margin: EdgeInsets.only(left: 28.0),
                                  padding: EdgeInsets.only(
                                      bottom: 4.0, left: 0.5, right: 0.5),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () => Routes.of(context)
                                              .toHoleModification(id, _index),
                                          child: Icon(
                                            Icons.edit,
                                            size: 32.0,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => showModal(
                                            context: context,
                                            configuration:
                                                FadeScaleTransitionConfiguration(),
                                            builder: (context) =>
                                                CustomAlertDialog(
                                                    FirebaseInteraction.of(
                                                            context)
                                                        .deleteHole,
                                                    index: _index,
                                                    id: id),
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            size: 32.0,
                                          ),
                                        ),
                                      ]),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    /// Modify howth's score!
                                    IconButtonPair(context, _index, id,
                                        onAdd: (currentHole) {
                                      Score updatedScore = currentHole.holeScore
                                          .updateScore(true, 1);
                                      Hole updatedHole = currentHole.updateHole(
                                          newScore: updatedScore);
                                      return updatedHole;
                                    }, onSubtract: (currentHole) {
                                      Score updatedScore = currentHole.holeScore
                                          .updateScore(true, -1);
                                      Hole updatedHole = currentHole.updateHole(
                                          newScore: updatedScore);
                                      return updatedHole;
                                    }),

                                    /// Modify the hole number!
                                    IconButtonPair(context, _index, id,
                                        iconColor: Palette.maroon,
                                        onAdd: (currentHole) {
                                      Hole updatedHole =
                                          currentHole.updateNumber(1);
                                      return updatedHole;
                                    }, onSubtract: (currentHole) {
                                      Hole updatedHole =
                                          currentHole.updateNumber(-1);
                                      return updatedHole;
                                    }),

                                    /// Modify the opposition score!
                                    IconButtonPair(context, _index, id,
                                        onAdd: (currentHole) {
                                      Score updatedScore = currentHole.holeScore
                                          .updateScore(false, 1);
                                      Hole updatedHole = currentHole.updateHole(
                                          newScore: updatedScore);
                                      return updatedHole;
                                    }, onSubtract: (currentHole) {
                                      Score updatedScore = currentHole.holeScore
                                          .updateScore(false, -1);
                                      Hole updatedHole = currentHole.updateHole(
                                          newScore: updatedScore);
                                      return updatedHole;
                                    }),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ),

                    /// Display the [lastUpdated] formatted.
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.0),
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Selector<FirebaseViewModel, String>(
                        selector: (_, model) => model
                            .entryFromId(id)
                            .holes
                            .elementAt(index)
                            .prettyLastUpdated,
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
                      margin: EdgeInsets.symmetric(horizontal: 3.0),
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Selector<FirebaseViewModel, String>(
                        selector: (_, model) => model
                            .entryFromId(id)
                            .holes
                            .elementAt(index)
                            .comment,
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
        ),
      ),
    );
  }
}
