import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:tuple/tuple.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/app/modification/modify_competition.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/widgets/alert_dialog.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';
import 'package:howth_golf_live/widgets/app_bars/competitions_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CompetitionsPage extends StatelessWidget {
  /// Builds an individual tile.
  static Widget _tileBuilder(BuildContext context, int id, bool isAdmin) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
        trailing: Icon(isAdmin ? null : Icons.keyboard_arrow_right,
            color: Palette.maroon),
        title: Selector<FirebaseViewModel, String>(
          selector: (_, model) => model.entryFromId(id).title,
          builder: (_, title, __) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Align(
              alignment: Alignment.centerLeft,
              key: ValueKey<String>(title),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ),
        subtitle: Row(children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 15.0),
            decoration: UIToolkit.rightSideBoxDecoration,
            child: Selector<FirebaseViewModel, String>(
              selector: (_, model) => model.entryFromId(id).date,
              builder: (_, date, __) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(
                  date,
                  key: ValueKey<String>(date),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyles.cardSubTitle,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Selector<FirebaseViewModel, Score>(
              selector: (_, model) => model.entryFromId(id).score,
              builder: (_, score, __) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Container(
                  child: ComplexScore(score),
                  key: ValueKey<Score>(score),
                ),
              ),
            ),
          )
        ]),
      );

  /// Builds the list of tiles.
  ///
  /// This method must be passed into [CompetiionsPageAppBar] as
  /// the [TabBarView] needs to be built there.
  Widget _buildElementsList(
    BuildContext context,
    String _searchText,
    bool isCurrentTab,
    bool hasVisited,
    GlobalKey _titleKey,
    GlobalKey _dateKey,
    GlobalKey _scoreKey,
  ) {
    /// Listen to [UserStatusViewModel].
    var _userStatus = Provider.of<UserStatusViewModel>(context);

    return Selector<FirebaseViewModel, Tuple3<int, QuerySnapshot, bool>>(
      selector: (_, model) {
        return Tuple3(
          model.competitionsItemCount(hasVisited, isCurrentTab, _searchText),
          model.currentSnapshot,
          model.activeElements(hasVisited, isCurrentTab, _searchText).isEmpty,
        );
      },

      /// Uses [Tuple3] to select 3 pieces of data. If any of these change, this child
      /// must rebuild.
      ///
      /// [data.item1] is the number of competitions.
      /// [data.item2] is the current [QuerySnapshot]. If it is [null], a loading spinner is shown.
      /// [data.item3] is whether the active competitions is empty, which take into account the search text,
      ///              the current tab and if the user has visited or not.
      builder: (context, data, child) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: data.item2 == null
            ? UIToolkit.loadingSpinner
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 100.0),

                /// Value accounts for the fact that if there are no entries (data.item3)
                /// then the item count will still be 1 for [UIToolkit.getNoDataText].
                key: ValueKey<int>(data.item3 ? data.item1 - 1 : data.item1),
                itemCount: data.item1,
                itemBuilder: (context, index) {
                  if (!hasVisited && index == 0 && isCurrentTab) {
                    return UIToolkit.exampleCompetition(
                      context,
                      _titleKey,
                      _dateKey,
                      _scoreKey,
                    );
                  } else if (data.item3) {
                    /// In the case where the user searched for something with no results,
                    /// return a [Text] widget to notify the user of that.
                    return UIToolkit.getNoDataText(Strings.noCompetitions);
                  }

                  /// Corrects the fault in index caused by the [UIToolkit.exampleCompetition].
                  int competitionIndex = index;
                  if (!hasVisited && isCurrentTab) competitionIndex--;

                  /// Fetch the [id] of the current competition.
                  ///
                  /// Does not listen to the [FirebaseViewModel] as the [id] is immutable.
                  var _firebaseModel =
                      Provider.of<FirebaseViewModel>(context, listen: false);
                  int id = _firebaseModel
                      .activeElements(
                        hasVisited,
                        isCurrentTab,
                        _searchText,
                      )[competitionIndex]
                      .id;

                  /// If the competition was deleted, the [id] would equate to [null] for
                  /// a split second. Returning a container prevents any error during that
                  /// time.
                  if (id == null) return Container();

                  return ComplexCard(
                    child: _tileBuilder(
                      context,
                      id,
                      _userStatus.isAdmin,
                    ),
                    onTap: () => Routes.of(context).toCompetition(id),
                    iconButton: !_userStatus.isAdmin
                        ? null
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.only(top: 10.0),
                                icon: Icon(Icons.edit),
                                onPressed: () => showModal(
                                  context: context,
                                  configuration: UIToolkit.modalConfiguration(),
                                  builder: (context) => ModifyCompetition(id),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                padding: EdgeInsets.only(bottom: 10.0),

                                /// When deleting a [DatabaseEntry], prompts the user to double check their intent
                                /// is to do so as this can have major consquences if an accident.
                                onPressed: () => showModal(
                                  context: context,
                                  configuration: UIToolkit.modalConfiguration(
                                    isDeletion: true,
                                  ),
                                  builder: (context) => CustomAlertDialog(
                                      FirebaseInteraction.of(context)
                                          .deleteCompetition,
                                      id: id),
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);

    bool _hasAccess = _userStatus.isAdmin;

    Widget floatingActionButton = _hasAccess
        ? UIToolkit.createButton(
            context: context,
            primaryText: Strings.newCompetition,
            secondaryText: Strings.tapEditCompetition)
        : null;

    /// Showcase keys.
    final GlobalKey _titleKey = GlobalKey();
    final GlobalKey _dateKey = GlobalKey();
    final GlobalKey _scoreKey = GlobalKey();
    final GlobalKey _searchKey = GlobalKey();
    final GlobalKey _currentTabKey = GlobalKey();
    final GlobalKey _helpsKey = GlobalKey();
    final GlobalKey _archivedTabKey = GlobalKey();

    List<GlobalKey> keys = [
      _searchKey,
      _helpsKey,
      _currentTabKey,
      _archivedTabKey,
      _titleKey,
      _dateKey,
      _scoreKey
    ];

    /// Start the showcase if the user has never visited this page before.
    if (!_userStatus.hasVisited(Strings.competitionsText)) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(
          const Duration(milliseconds: 610),
          () => ShowCaseWidget.of(context).startShowCase(keys),
        ),
      );
    }

    return Scaffold(
        body: DefaultTabController(
            length: 2,
            child: CompetitionsPageAppBar(
              _buildElementsList,
              hasVisited: _userStatus.hasVisited(Strings.competitionsText),
              keys: keys,
            )),
        floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: floatingActionButton),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
