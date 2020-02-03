import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/creation/create_hole.dart';
import 'package:howth_golf_live/pages/unique/hole.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
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
  bool hasAccess;

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
  IconData _getTrailingIcon(Hole currentHole) {
    String score = currentHole.holeScore.toString().toLowerCase();
    if (hasAccess) {
      return null;
    } else if (score.contains('up')) {
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
      return CompetitionDetails(currentData, hasAccess);
    }

    /// If there are no holes, display a small text saying
    /// there are no holes yet!
    if (currentData.holes.length == 0) {
      return Center(
          child: Padding(
              child: Text(
                "No hole data found for this competition!",
                style: Toolkit.cardTitleTextStyle,
              ),
              padding: EdgeInsets.only(top: 25.0)));
    }

    Hole currentHole = currentData.holes[index - 1];
    IconData trailingIcon = _getTrailingIcon(currentHole);
    return ComplexCard(
      child: BaseListTile(
        leadingChild:
            Toolkit.getLeadingColumn("HOLE", currentHole.holeNumber.toString()),
        trailingIconData: trailingIcon,
        subtitleMaxLines: 1,
        subtitleText: _formatPlayerList(currentHole.players),
        titleText: currentHole.holeScore.toString(),
      ),
      iconButton: hasAccess
          ? IconButton(
              icon: Icon(Icons.remove_circle_outline,
                  color: Palette.dark, size: 22.0),
              onPressed: () {
                _deleteHole(index);
              },
            )
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HolePage(currentData.title, currentData)));
      },
    );
  }

  /// In order to get access to a competition, the [codeAttempt]
  /// made must be equal to the [currentData.id].
  ///
  /// Upon success, adds the [currentData.id] to the list of strings
  /// stored in [SharedPreferences], with a key value equal to [Toolkit.activeCompetitionsText],
  /// signifying that this user has access to this competition.
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

  /// Deletes the holes at the given [index] within the list of holes
  /// for this competition.
  void _deleteHole(int index) {
    final int currentId = currentData.id;
    Future<QuerySnapshot> newData = Toolkit.stream.first;

    setState(() {
      newData.then((QuerySnapshot snapshot) {
        DataBaseInteraction.deleteHole(context, snapshot, index, currentId);
      });
    });
  }

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

            /// If there is no hole data, [_tileBuilder] must be called one more
            /// time in order to return the text notifying the user that no hole
            /// data has been added yet.
            ///
            /// Both cases must add atleast one to account for the competition details
            /// at index 0.
            int _countBonus = currentData.holes.length == 0 ? 2 : 1;

            return ListView.builder(
                itemCount: currentData.holes.length + _countBonus,
                itemBuilder: _tileBuilder);
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
