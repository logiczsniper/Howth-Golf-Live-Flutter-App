import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:howth_golf_live/domain/firebase_interation.dart';
import 'package:howth_golf_live/presentation/utils.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/alert_dialog.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:howth_golf_live/widgets/app_bars/competitions_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';

import 'package:howth_golf_live/pages/creation/create_competition.dart';
import 'package:howth_golf_live/pages/unique/competition.dart';

import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/domain/privileges.dart';

class CompetitionsPage extends StatefulWidget {
  @override
  _CompetitionsPageState createState() => _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> {
  AsyncSnapshot<QuerySnapshot> _snapshot;

  /// Handles special situations with [filteredElements].
  ///
  /// In the case where the data is still being fetched, return a
  /// loading widget [SpinKitPulse].
  static ListTile _checkFilteredElements(List filteredElements) {
    if (filteredElements == null)
      return ListTile(
          title: Center(
              child: SpinKitPulse(
        color: Palette.dark,
        size: 45,
        duration: Duration(milliseconds: 350),
      )));

    return null;
  }

  static Widget _tileBuilder(
          BuildContext context, DataBaseEntry currentEntry, int index) =>
      ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
          title: Text(
            currentEntry.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          subtitle: Row(children: <Widget>[
            Container(
                padding: EdgeInsets.only(right: 15.0),
                decoration: UIToolkit.rightSideBoxDecoration,
                child: Text(currentEntry.date,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: UIToolkit.cardSubTitleTextStyle)),
            Padding(
              child: ComplexScore(
                  currentEntry.location.isHome, currentEntry.score),
              padding: EdgeInsets.only(left: 15.0),
            )
          ]),
          trailing: Icon(
            Privileges.adminStatus(context: context)
                ? null
                : Icons.keyboard_arrow_right,
          ));

  Widget _buildElementsList(String _searchText, bool isCurrentTab) =>
      OpacityChangeWidget(
          key: ValueKey(DateTime.now()),
          target: AnimatedSwitcher(
              duration: Duration(milliseconds: 350),
              child: StreamBuilder<QuerySnapshot>(
                  key: ValueKey(DateTime.now()),
                  stream: DataBaseInteraction.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (UIToolkit.checkSnapshot(snapshot) != null)
                      return UIToolkit.checkSnapshot(snapshot);

                    _snapshot = snapshot;

                    DocumentSnapshot document = snapshot.data.documents[0];

                    List<DataBaseEntry> parsedElements =
                        DataBaseInteraction.getDataBaseEntries(document);

                    List<DataBaseEntry> filteredElements =
                        Utils.filterElements(parsedElements, _searchText);

                    if (_checkFilteredElements(filteredElements) != null)
                      return _checkFilteredElements(filteredElements);

                    /// At the 0th index of [sortedElements] will be the currentElements,
                    /// and at the 1st index will be the archivedElements.
                    List<List<DataBaseEntry>> sortedElements =
                        Utils.sortElements(filteredElements);

                    List<DataBaseEntry> activeElements =
                        isCurrentTab ? sortedElements[0] : sortedElements[1];

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 100.0),
                      itemCount: activeElements.length == 0
                          ? 1
                          : activeElements.length,
                      itemBuilder: (BuildContext context, int index) {
                        /// In the case where the user searched for something with no results,
                        /// return a [Text] widget to notify the user of that.
                        if (activeElements.length == 0) {
                          return ListTile(
                              title: Center(
                                  child: Text(
                                      "No ${Strings.competitionsText.toLowerCase()} found!",
                                      style: UIToolkit.noDataTextStyle)));
                        }

                        DataBaseEntry currentEntry = activeElements[index];

                        /// Fetches [SharedPreferences] to pass as initial values into
                        /// the [SpecificCompetitionPage].
                        void Function() toCompetition = () {
                          final Future<SharedPreferences> preferences =
                              SharedPreferences.getInstance();
                          final bool hasAccess =
                              Privileges.adminStatus(context: context) ||
                                  Privileges.managerStatus(currentEntry,
                                      context: context);

                          preferences.then((SharedPreferences preferences) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SpecificCompetitionPage(currentEntry,
                                              hasAccess, index))));
                        };

                        return ComplexCard(
                            child: _tileBuilder(context, currentEntry, index),
                            onTap: toCompetition,
                            iconButton: Privileges.adminStatus(context: context)
                                ? IconButton(
                                    icon: Icon(Icons.remove_circle_outline),

                                    /// When deleting a [DataBaseEntry], prompts the user to double check their intent
                                    /// is to do so as this can have major consquences if an accident.
                                    onPressed: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomAlertDialog(
                                                  snapshot: _snapshot,
                                                  currentEntry: currentEntry),
                                        ))
                                : null);
                      },
                    );
                  })));

  /// Push to [CreateCompetition] page.
  void _toCompetitionCreation() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateCompetition(_snapshot)));
  }

  @override
  Widget build(BuildContext context) {
    Widget floatingActionButton = Privileges.adminStatus(context: context)
        ? UIToolkit.createButton(
            onPressed: _toCompetitionCreation, text: 'Add a Competition')
        : null;
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: CompetitionsPageAppBar(_buildElementsList,
              title: Strings.competitionsText)),
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
