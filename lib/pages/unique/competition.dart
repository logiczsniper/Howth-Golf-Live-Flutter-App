import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/list_tile.dart';
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

  /// Turn a list of players, [playerList], into one string with
  /// those individual player names separated by commas, apart from the last
  /// player in the list.
  static String _formatPlayerList(List playerList) {
    String output = '';
    bool isLastPlayer = false;
    for (String player in playerList) {
      output += player.toString();
      isLastPlayer = playerList.indexOf(player) == playerList.length - 1;
      if (!isLastPlayer) {
        output += ', ';
      }
    }
    return output;
  }

  /// The [trailingIcon] depends on [holeScore] - whether or not Howth's team
  /// is 'up', 'under' or tied of the [currentHole].
  static IconData _getTrailingIcon(Hole currentHole) {
    String score = currentHole.holeScore.toLowerCase();
    if (score.contains('up')) {
      return Icons.thumb_up;
    } else if (score.contains('under')) {
      return Icons.thumb_down;
    } else {
      return Icons.thumbs_up_down;
    }
  }

  Widget _tileBuilder(BuildContext context, int index) {
    /// The first element in the [ListView] should be the
    /// details of the competition, i.e. a [CompetitionDetails] widget.
    if (index == 0) {
      return CompetitionDetails(currentData);
    }

    Hole currentHole = currentData.holes[index - 1];
    IconData trailingIcon = _getTrailingIcon(currentHole);

    return Toolkit.getCard(Container(
        decoration: Toolkit.roundedRectBoxDecoration,
        child: BaseListTile(
          leadingChild: Toolkit.getLeadingColumn(
              "HOLE", currentHole.holeNumber.toString()),
          trailingIconData: trailingIcon,
          subtitleMaxLines: 1,
          subtitleText: _formatPlayerList(currentHole.players),
          titleText: currentHole.holeScore,
        )));
  }

  /// Gets all of the database entries, parses them, iterates through each [DataBaseEntry],
  /// until the [entry.id] is equivalent to [currentData.id]. It is this entry
  /// that we want fresh data for. Sets [currentData] to this new entry.
  Future<void> _refreshList() async {
    final int currentId = currentData.id;
    Future<QuerySnapshot> newData = Toolkit.stream.first;

    setState(() {
      newData.then((QuerySnapshot snapshot) {
        DocumentSnapshot document = snapshot.documents[0];
        List<DataBaseEntry> parsedOutput = Toolkit.getDataBaseEntries(document);

        for (DataBaseEntry entry in parsedOutput) {
          if (entry.id == currentId) {
            this.currentData = entry;
            break;
          }
        }
      });
    });
  }

  /// In order to get access to a competition, the [codeAttempt]
  /// made must be equal to the [currentData.id].
  ///
  /// Upon success, sets the [activeCompetitionText] in [SharedPreferences]
  /// to the [currentData.id], signifying that this device has access to this
  /// competition.
  bool _applyPrivileges(String codeAttempt) {
    if (codeAttempt == currentData.id.toString()) {
      final preferences = SharedPreferences.getInstance();
      preferences.then((SharedPreferences preferences) {
        preferences.setString(
            Toolkit.activeCompetitionText, currentData.id.toString());
      });
      return true;
    }
    return false;
  }

  RefreshIndicator get _refreshIndicator => RefreshIndicator(
        displacement: 80.0,
        color: Palette.maroon,
        backgroundColor: Palette.light,
        child: OpacityChangeWidget(
            target: ListView.builder(
          itemBuilder: _tileBuilder,
          itemCount: currentData.holes.length + 1,
        )),
        onRefresh: _refreshList,
      );

  /// TODO: build out method
  void addHole() {}

  @override
  initState() {
    super.initState();
    currentData = widget.competition;
  }

  @override
  Widget build(BuildContext context) {
    MyFloatingActionButton floatingActionButton = widget.hasAccess
        ? MyFloatingActionButton(onPressed: addHole, text: 'Add a Hole')
        : null;
    return Scaffold(
      appBar:
          CodeFieldBar(currentData.title, _applyPrivileges, widget.hasAccess),
      body: _refreshIndicator,
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Palette.light,
    );
  }
}
