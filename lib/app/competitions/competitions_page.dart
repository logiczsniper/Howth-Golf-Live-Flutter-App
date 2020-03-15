import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/services/models.dart';

import 'package:howth_golf_live/widgets/alert_dialog.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';
import 'package:howth_golf_live/widgets/app_bars/competitions_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CompetitionsPage extends StatelessWidget {
  static Widget _tileBuilder(
          BuildContext context, DatabaseEntry currentEntry, bool isAdmin) =>
      ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
          title: Text(currentEntry.title,
              overflow: TextOverflow.ellipsis, maxLines: 2),
          subtitle: Row(children: <Widget>[
            Container(
                padding: EdgeInsets.only(right: 15.0),
                decoration: UIToolkit.rightSideBoxDecoration,
                child: Text(currentEntry.date,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyles.cardSubTitleTextStyle)),
            Padding(
                child: ComplexScore(
                    currentEntry.location.isHome, currentEntry.score),
                padding: EdgeInsets.only(left: 15.0))
          ]),
          trailing: Icon(isAdmin ? null : Icons.keyboard_arrow_right));

  Widget _buildElementsList(
      BuildContext context, String _searchText, bool isCurrentTab) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);
    var _firebaseModel = Provider.of<FirebaseViewModel>(context);

    if (_firebaseModel.currentSnapshot == null) return UIToolkit.loadingSpinner;

    List<DatabaseEntry> filteredElements =
        _firebaseModel.filteredElements(_searchText);

    /// At the 0th index of [sortedElements] will be the currentElements,
    /// and at the 1st index will be the archivedElements.
    List<List<DatabaseEntry>> sortedElements =
        _firebaseModel.sortedElements(filteredElements);

    List<DatabaseEntry> activeElements =
        isCurrentTab ? sortedElements[0] : sortedElements[1];

    return OpacityChangeWidget(
        key: ValueKey(DateTime.now()),
        target: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 100.0),
                itemCount:
                    activeElements.length == 0 ? 1 : activeElements.length,
                itemBuilder: (context, index) {
                  /// In the case where the user searched for something with no results,
                  /// return a [Text] widget to notify the user of that.
                  if (activeElements.length == 0) {
                    return ListTile(
                        title: Center(
                            child: Text(Strings.noCompetitions,
                                style: TextStyles.noDataTextStyle)));
                  }

                  DatabaseEntry currentEntry = activeElements[index];

                  return ComplexCard(
                      child: _tileBuilder(
                          context, currentEntry, _userStatus.isAdmin),
                      onTap: () => Routes.toCompetition(context, currentEntry),
                      iconButton: _userStatus.isAdmin
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.only(top: 10.0),
                                    icon: Icon(Icons.edit),
                                    onPressed: () =>
                                        Routes.toCompetitionModification(
                                            context, currentEntry),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      padding: EdgeInsets.only(bottom: 10.0),

                                      /// When deleting a [DatabaseEntry], prompts the user to double check their intent
                                      /// is to do so as this can have major consquences if an accident.
                                      onPressed: () => showModal(
                                          context: context,
                                          configuration:
                                              FadeScaleTransitionConfiguration(),
                                          builder: (context) =>
                                              CustomAlertDialog(
                                                  FirebaseInteration(context)
                                                      .deleteCompetition,
                                                  currentEntry: currentEntry))),
                                ])
                          : null);
                })));
  }

  @override
  Widget build(BuildContext context) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);

    bool _hasAccess = _userStatus.isAdmin;

    Widget floatingActionButton = _hasAccess
        ? UIToolkit.createButton(context: context, text: Strings.newCompetition)
        : null;

    return Scaffold(
        body: DefaultTabController(
            length: 2,
            child: CompetitionsPageAppBar(_buildElementsList,
                title: Strings.competitionsText)),
        floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: floatingActionButton),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
