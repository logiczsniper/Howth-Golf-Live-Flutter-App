import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/create_hole.dart';
import 'package:howth_golf_live/pages/unique/hole.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/competition_details/competition_details.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/buttons/floating_action_button.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class SpecificCompetitionPage extends StatefulWidget {
  final DataBaseEntry competition;
  final bool hasAccess;

  SpecificCompetitionPage(this.competition, this.hasAccess);

  @override
  SpecificCompetitionPageState createState() => SpecificCompetitionPageState();
}

class SpecificCompetitionPageState extends State<SpecificCompetitionPage> {
  DataBaseEntry currentData;
  bool hasAccess;

  /// In order to get access to a competition, the [codeAttempt]
  /// made must be equal to the [currentData.id].
  ///
  /// Upon success, adds the [currentData.id] to the list of strings
  /// stored in [SharedPreferences], with a key value equal to [Toolkit.activeCompetitionsText],
  /// signifying that this user has access to this competition.
  ///
  /// [setState] is also called to rebuild the page with the potentially newly aquired
  /// privileges.
  Future<bool> _applyPrivileges(String codeAttempt) {
    if (codeAttempt == currentData.id.toString()) {
      final preferences = SharedPreferences.getInstance();
      preferences.then((SharedPreferences preferences) {
        /// Get current competitions that the user has access to.
        List<String> competitionsAccessed =
            preferences.getStringList(Toolkit.activeCompetitionsText) ?? [];

        /// Append this competition.
        competitionsAccessed.add(currentData.id.toString());

        /// Write this to [SharedPreferences].
        preferences.setStringList(
            Toolkit.activeCompetitionsText, competitionsAccessed);
      });
      setState(() {
        hasAccess = true;
      });
      return Future.value(true);
    }

    setState(() {
      hasAccess = false;
    });
    return Future.value(false);
  }

  /// Push to the [CreateHole] page.
  void _addHole() {
    final int currentId = currentData.id;
    Future<QuerySnapshot> newData = Toolkit.stream.first;

    setState(() {
      newData.then((QuerySnapshot snapshot) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateHole(snapshot, currentId)));
      });
    });
  }

  /// Get the styled and positioned widget to display the name of the player(s)
  /// for the designated [hole].
  Expanded _getPlayer(Hole hole, String text, int index, {bool away = false}) =>
      Expanded(
          child: Align(
              alignment: away ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color:
                          index % 2 != 0 ? Palette.light : Palette.tableLight,
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Text(text,
                      textAlign: away ? TextAlign.right : TextAlign.left,
                      style: Toolkit.cardSubTitleTextStyle))));

  /// Gets the properly padded and styled score widget.
  Container _getScore(String text, {bool away = false}) => Container(
      child: Text(text, style: Toolkit.leadingChildTextStyle),
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
  Widget _rowBuilder(Hole hole, bool isHome, String opposition, int index) =>
      GestureDetector(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(5.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /// Home team section.
                  Expanded(
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                        /// Home player.
                        _getPlayer(
                            hole,
                            isHome
                                ? Toolkit.formatPlayerList(hole.players)
                                : opposition,
                            index),

                        /// Home score.
                        _getScore(isHome
                            ? hole.holeScore.howth
                            : hole.holeScore.opposition)
                      ])),

                  /// Hole Number

                  Toolkit.getHoleNumberDecorated(hole.holeNumber),

                  /// Away team section.
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      /// Away team score.
                      _getScore(
                          !isHome
                              ? hole.holeScore.howth
                              : hole.holeScore.opposition,
                          away: true),

                      /// Away team player.
                      _getPlayer(
                          hole,
                          !isHome
                              ? Toolkit.formatPlayerList(hole.players)
                              : opposition,
                          index,
                          away: true),
                    ],
                  ))
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HolePage(currentData, index - 2, hasAccess)));
          });

  @override
  initState() {
    super.initState();
    currentData = widget.competition;
    hasAccess = widget.hasAccess;
  }

  @override
  Widget build(BuildContext context) {
    /// If the user is an admin or manager, they are able to both
    /// see and press the [MyFloatingActionButton] in order to create
    /// a hole.
    MyFloatingActionButton floatingActionButton = hasAccess
        ? MyFloatingActionButton(onPressed: _addHole, text: 'Add a Hole')
        : null;
    return Scaffold(
      appBar: CodeFieldBar(currentData.title, _applyPrivileges, hasAccess),
      body: OpacityChangeWidget(
        target: StreamBuilder<QuerySnapshot>(
          stream: Toolkit.stream,
          builder: (context, snapshot) {
            if (Toolkit.checkSnapshot(snapshot) != null)
              return Toolkit.checkSnapshot(snapshot);

            DocumentSnapshot document = snapshot.data.documents[0];

            List<DataBaseEntry> parsedElements =
                Toolkit.getDataBaseEntries(document);

            for (DataBaseEntry dataBaseEntry in parsedElements) {
              if (dataBaseEntry.id == currentData.id) {
                /// This entry in [parsedElements] is the current competition.
                currentData = dataBaseEntry;
              }
            }

            int _countBonus = currentData.holes.length == 0 ? 3 : 2;

            return ListView.separated(
              padding: EdgeInsets.only(bottom: 100.0),
              separatorBuilder: (BuildContext context, int index) {
                if (index != 0 && index != 1)
                  return Divider(
                    height: 30.0,
                    indent: 50.0,
                    endIndent: 50.0,
                    thickness: 1.5,
                    color: Palette.divider,
                  );
                else
                  return Container();
              },
              itemBuilder: (BuildContext context, int index) {
                if (index == 0)
                  return CompetitionDetails(currentData, hasAccess);
                else if (index == 1)
                  return Toolkit.getVersus(currentData, "Howth Golf Club");
                else if (currentData.holes.length == 0)
                  return Center(
                      child: Padding(
                          child: Text(
                            "No hole data found for the ${currentData.title}!",
                            style: Toolkit.noDataTextStyle,
                          ),
                          padding: EdgeInsets.only(top: 25.0)));
                else
                  return _rowBuilder(
                    currentData.holes[index - 2],
                    currentData.location.isHome,
                    currentData.opposition,
                    index,
                  );
              },
              itemCount: currentData.holes.length + _countBonus,
            );
          },
        ),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Palette.light,
    );
  }
}
