import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:howth_golf_live/widgets/app_bars/competitions_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/buttons/floating_action_button.dart';

import 'package:howth_golf_live/pages/creation/create_competition.dart';
import 'package:howth_golf_live/pages/unique/competition.dart';

import 'package:howth_golf_live/static/toolkit.dart';
import 'package:howth_golf_live/static/privileges.dart';

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
  /// In the case where the user searched for something with no results,
  /// return a [Text] widget to notify the user of that.
  static ListTile _checkFilteredElements(List<DataBaseEntry> filteredElements) {
    if (filteredElements == null)
      return ListTile(
          title: Center(
              child: SpinKitPulse(
        color: Palette.dark,
        size: 45,
        duration: Duration(milliseconds: 850),
      )));

    if (filteredElements == [])
      return ListTile(
          title: Center(
              child: Text("No ${Toolkit.competitionsText.toLowerCase()} found!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Palette.dark,
                      fontWeight: FontWeight.w300))));
    return null;
  }

  /// Based on the user's [_searchText], filters the competitions.
  ///
  /// Utilizes the [DataBaseEntry.values] function to get all of the
  /// data for the entry in one string.
  static List<DataBaseEntry> _filterElements(
      List<DataBaseEntry> parsedElements, String _searchText) {
    List<DataBaseEntry> filteredElements = List();
    if (_searchText.isNotEmpty) {
      parsedElements.forEach((DataBaseEntry currentEntry) {
        String entryString = currentEntry.values.toLowerCase();
        String query = _searchText.toLowerCase();
        if (entryString.contains(query)) {
          filteredElements.add(currentEntry);
        }
      });
      return filteredElements;
    }
    return parsedElements;
  }

  /// Transform the strings found in the database into
  /// a [DateTime] object.
  ///
  /// The format provided by field: 'YYYY-DD-MM HH:MM'
  static DateTime _parseDate(String date, String time) =>
      DateTime.parse("$date $time");

  /// Sorts elements into either current or archived lists.
  static List<List<DataBaseEntry>> _sortElements(
      List<DataBaseEntry> filteredElements) {
    /// All entries are classified as current or archived.
    /// If the [competitionDate] is greater than 9 days in the past,
    /// it is archived. Otherwise, it is current.
    List<DataBaseEntry> currentElements = [];
    List<DataBaseEntry> archivedElements = [];
    for (DataBaseEntry filteredElement in filteredElements) {
      DateTime competitionDate =
          _parseDate(filteredElement.date, filteredElement.time);
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

  /// Get whether or not the user [isAdmin].
  ///
  /// If they are, they are granted access to modify any
  /// competition, create and delete competitions.
  static bool _isAdmin(BuildContext context) {
    final Privileges arguments = ModalRoute.of(context).settings.arguments;
    final bool isAdmin = arguments.isAdmin ?? false;
    return isAdmin;
  }

  /// Get whether or not the user [isManager].
  ///
  /// This would grant them admin privileges however only to
  /// the competition which they are admin of. In this case,
  /// tests if they are an given these rights for [currentEntry].
  static bool _isManager(BuildContext context, DataBaseEntry currentEntry) {
    final Privileges arguments = ModalRoute.of(context).settings.arguments;
    if (arguments.competitionAccess == null) return false;
    final bool isManager =
        arguments.competitionAccess.contains(currentEntry.id.toString());
    return isManager;
  }

  static Widget _tileBuilder(
          BuildContext context, DataBaseEntry currentEntry) =>
      BaseListTile(
          leadingChild: Toolkit.getLeadingText(
              "${currentEntry.score.howth} - ${currentEntry.score.opposition}"),
          trailingIconData:
              _isAdmin(context) ? null : Icons.keyboard_arrow_right,
          subtitleMaxLines: 1,
          subtitleText: currentEntry.date,
          titleText: currentEntry.title);

  Widget _buildElementsList(String _searchText, bool isCurrentTab) =>
      OpacityChangeWidget(
          target: StreamBuilder<QuerySnapshot>(
              stream: Toolkit.stream,
              builder: (context, snapshot) {
                if (Toolkit.checkSnapshot(snapshot) != null)
                  return Toolkit.checkSnapshot(snapshot);

                _snapshot = snapshot;

                DocumentSnapshot document = snapshot.data.documents[0];

                List<DataBaseEntry> parsedElements =
                    Toolkit.getDataBaseEntries(document);

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
                  itemCount: activeElements.length,
                  itemBuilder: (BuildContext context, int index) {
                    DataBaseEntry currentEntry = activeElements[index];
                    Function toCompetition = () {
                      final preferences = SharedPreferences.getInstance();
                      preferences.then((SharedPreferences preferences) {
                        final bool hasAccess = _isAdmin(context) ||
                            _isManager(context, currentEntry);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificCompetitionPage(
                                    currentEntry, hasAccess)));
                      });
                    };
                    return ComplexCard(
                        child: _tileBuilder(context, currentEntry),
                        onTap: toCompetition,
                        iconButton: _isAdmin(context)
                            ? IconButton(
                                icon: Icon(Icons.remove_circle_outline,
                                    color: Palette.dark, size: 22.0),
                                onPressed: () {
                                  _showAlertDialog(
                                      context, activeElements[index], snapshot);
                                },
                              )
                            : null);
                  },
                );
              }));

  /// When deleting a [DataBaseEntry], prompts the user to double check their intent
  /// is to do so as this can have major consquences if an accident.
  _showAlertDialog(BuildContext context, DataBaseEntry currentEntry,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Are you sure?", style: Toolkit.cardTitleTextStyle),
      content: Text("This action is irreversible.",
          style: Toolkit.cardSubTitleTextStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel", style: Toolkit.dialogTextStyle),
          onPressed: Navigator.of(context).pop,
        ),
        FlatButton(
          child: Text("Continue", style: Toolkit.dialogTextStyle),
          onPressed: () {
            Navigator.of(context).pop();
            DataBaseInteraction.deleteCompetition(currentEntry, snapshot);
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => alertDialog,
    );
  }

  /// Push to [CreateCompetition] page.
  void _addCompetition() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateCompetition(_snapshot)));
  }

  @override
  Widget build(BuildContext context) {
    MyFloatingActionButton floatingActionButton = _isAdmin(context)
        ? MyFloatingActionButton(
            onPressed: _addCompetition, text: 'Add a Competition')
        : null;
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: CompetitionsPageAppBar(_buildElementsList,
              title: Toolkit.competitionsText)),
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Palette.light,
    );
  }
}
