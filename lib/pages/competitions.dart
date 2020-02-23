import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:howth_golf_live/domain/firebase_interation.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';
import 'package:howth_golf_live/widgets/list_tile.dart';
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
        duration: Duration(milliseconds: 850),
      )));

    return null;
  }

  /// Based on the user's [_searchText], filters the competitions.
  ///
  /// Utilizes the [DataBaseEntry.toString] function to get all of the
  /// data for the entry in one string.
  /// TODO: PR&L
  static List<DataBaseEntry> _filterElements(
      List<DataBaseEntry> parsedElements, String _searchText) {
    List<DataBaseEntry> filteredElements = List();
    if (_searchText.isNotEmpty) {
      parsedElements.forEach((DataBaseEntry currentEntry) {
        String entryString = currentEntry.toString().toLowerCase();
        String query = _searchText.toLowerCase();
        if (entryString.contains(query)) {
          filteredElements.add(currentEntry);
        }
      });
      return filteredElements;
    }
    return parsedElements;
  }

  /// Sorts elements into either current or archived lists.
  /// TODO: PR&L
  static List<List<DataBaseEntry>> _sortElements(
      List<DataBaseEntry> filteredElements) {
    /// All entries are classified as current or archived.
    /// If the [competitionDate] is greater than 9 days in the past,
    /// it is archived. Otherwise, it is current.
    List<DataBaseEntry> currentElements = [];
    List<DataBaseEntry> archivedElements = [];
    for (DataBaseEntry filteredElement in filteredElements) {
      DateTime competitionDate =
          DateTime.parse("${filteredElement.date} ${filteredElement.time}");
      int daysFromNow = competitionDate.difference(DateTime.now()).inDays.abs();

      bool inPast = competitionDate.isBefore(DateTime.now());
      if (daysFromNow >= 8 && inPast) {
        archivedElements.add(filteredElement);
      } else {
        currentElements.add(filteredElement);
      }
    }
    return [currentElements, archivedElements];
  }

  static Widget _tileBuilder(
          BuildContext context, DataBaseEntry currentEntry, int index) =>
      BaseListTile(
        /// The score of the competition.
        ///
        /// Uses [RichText] to display fractions when needed.
        leadingChild:
            ComplexScore(currentEntry.location.isHome, currentEntry.score),

        /// If [Privileges.adminStatus], the remove competition button will rest in place of this
        /// [trailingIconData] above this [BaseListTile] in the [Stack]. Hence, no [IconData]
        /// is provided in this case.
        trailingIconData: Privileges.adminStatus(context: context)
            ? null
            : Icons.keyboard_arrow_right,
        subtitleMaxLines: 1,
        subtitleText: currentEntry.date,
        titleText: currentEntry.title,
        index: index,
      );

  Widget _buildElementsList(String _searchText, bool isCurrentTab) =>
      OpacityChangeWidget(
          key: ValueKey(DateTime.now()),
          target: AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: StreamBuilder<QuerySnapshot>(
                  key: ValueKey(DateTime.now()),
                  stream: DataBaseInteraction.stream,
                  builder: (context, snapshot) {
                    if (UIToolkit.checkSnapshot(snapshot) != null)
                      return UIToolkit.checkSnapshot(snapshot);

                    _snapshot = snapshot;

                    DocumentSnapshot document = snapshot.data.documents[0];

                    List<DataBaseEntry> parsedElements =
                        DataBaseInteraction.getDataBaseEntries(document);

                    List<DataBaseEntry> filteredElements =
                        _filterElements(parsedElements, _searchText);

                    if (_checkFilteredElements(filteredElements) != null)
                      return _checkFilteredElements(filteredElements);

                    /// At the 0th index of [sortedElements] will be the currentElements,
                    /// and at the 1st index will be the archivedElements.
                    List<List<DataBaseEntry>> sortedElements =
                        _sortElements(filteredElements);

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
                                      builder: (context) =>
                                          SpecificCompetitionPage(currentEntry,
                                              hasAccess, index))));
                        };

                        return ComplexCard(
                            child: _tileBuilder(context, currentEntry, index),
                            onTap: toCompetition,
                            iconButton: Privileges.adminStatus(context: context)
                                ? IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      _showAlertDialog(context,
                                          activeElements[index], snapshot);
                                    },
                                  )
                                : null);
                      },
                    );
                  })));

  /// When deleting a [DataBaseEntry], prompts the user to double check their intent
  /// is to do so as this can have major consquences if an accident.
  /// TODO: remove alert dialog, abstraction
  _showAlertDialog(BuildContext context, DataBaseEntry currentEntry,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Are you sure?", style: UIToolkit.cardTitleTextStyle),
      content: Text(
        "This action is irreversible.",
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Palette.maroon),
          ),
          onPressed: Navigator.of(context).pop,
        ),
        FlatButton(
          child: Text(
            "OK",
            style: TextStyle(color: Palette.maroon),
          ),
          onPressed: () {
            DataBaseInteraction.deleteCompetition(
                context, currentEntry, snapshot);
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => alertDialog,
    );
  }

  /// Push to [CreateCompetition] page. TODO: refactor this name as well as _addHole
  void _addCompetition() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateCompetition(_snapshot)));
  }

  @override
  Widget build(BuildContext context) {
    Widget floatingActionButton = Privileges.adminStatus(context: context)
        ? UIToolkit.createButton(
            onPressed: _addCompetition, text: 'Add a Competition')
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
