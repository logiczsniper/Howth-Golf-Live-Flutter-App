import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
import 'package:howth_golf_live/services/models.dart';

import 'package:howth_golf_live/widgets/alert_dialog.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';
import 'package:howth_golf_live/widgets/app_bars/competitions_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:tuple/tuple.dart';

class CompetitionsPage extends StatelessWidget {
  static Widget _tileBuilder(BuildContext context, int id, bool isAdmin) =>
      ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
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
                padding: EdgeInsets.only(left: 15.0))
          ]),
          trailing: Icon(isAdmin ? null : Icons.keyboard_arrow_right,
              color: Palette.maroon));

  Widget _buildElementsList(
      BuildContext context,
      String _searchText,
      bool isCurrentTab,
      bool hasVisited,
      GlobalKey _titleKey,
      GlobalKey _dateKey,
      GlobalKey _scoreKey) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);

    // _userStatus.clearPreferences();

    return Selector<FirebaseViewModel, Tuple3<int, QuerySnapshot, bool>>(
      selector: (_, model) {
        return Tuple3(
          model.competitionsItemCount(hasVisited, isCurrentTab, _searchText),
          model.currentSnapshot,
          model.activeElements(hasVisited, isCurrentTab, _searchText).isEmpty,
        );
      },
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
                  var _firebaseModel =
                      Provider.of<FirebaseViewModel>(context, listen: false);
                  int id = _firebaseModel
                      .activeElements(hasVisited, isCurrentTab, _searchText)
                      .elementAt(competitionIndex)
                      .id;

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
                                onPressed: () => Routes.of(context)
                                    .toCompetitionModification(id),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                padding: EdgeInsets.only(bottom: 10.0),

                                /// When deleting a [DatabaseEntry], prompts the user to double check their intent
                                /// is to do so as this can have major consquences if an accident.
                                onPressed: () => showModal(
                                  context: context,
                                  configuration:
                                      FadeScaleTransitionConfiguration(),
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

    if (!_userStatus.hasVisited(Strings.competitionsText)) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase(keys));
    }

    return Scaffold(
        body: DefaultTabController(
            length: 2,
            child: CompetitionsPageAppBar(_buildElementsList,
                title: Strings.competitionsText,
                hasVisited: _userStatus.hasVisited(Strings.competitionsText),
                keys: keys)),
        floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: floatingActionButton),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
