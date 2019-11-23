import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:howth_golf_live/custom_elements/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/custom_elements/competition_details_widgets/competition_details.dart';
import 'package:howth_golf_live/custom_elements/opacity_change.dart';
import 'package:howth_golf_live/custom_elements/buttons/floating_action_button.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';

class SpecificCompetitionPage extends StatefulWidget {
  final DataBaseEntry competition;
  final bool hasAccess;

  SpecificCompetitionPage(this.competition, this.hasAccess);

  @override
  SpecificCompetitionPageState createState() => SpecificCompetitionPageState();
}

class SpecificCompetitionPageState extends State<SpecificCompetitionPage> {
  DataBaseEntry currentData;

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

  static Column _getLeadingColumn(String smallText, String relevantNumber) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            smallText,
            style: Constants.cardSubTitleTextStyle.apply(fontSizeDelta: -1.5),
          ),
          Text(relevantNumber,
              style: TextStyle(
                  fontSize: 21.5,
                  color: Constants.primaryAppColorDark,
                  fontWeight: FontWeight.w400))
        ]);
  }

  Widget _tileBuilder(BuildContext context, int index) {
    if (index == 0) {
      return CompetitionDetails(currentData);
    }

    Hole currentHole = currentData.holes[index - 1];
    IconData trailingIcon = _getTrailingIcon(currentHole);

    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 1.85,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: Constants.roundedRectBoxDecoration,
            child: BaseListTile(
              leadingChild:
                  _getLeadingColumn("HOLE", currentHole.holeNumber.toString()),
              trailingWidget: Icon(trailingIcon,
                  color: Constants.primaryAppColorDark, size: 19.0),
              subtitleMaxLines: 1,
              subtitleText: _formatPlayerList(currentHole.players),
              titleText: currentHole.holeScore,
            )));
  }

  static List<DataBaseEntry> _getDataBaseEntries(DocumentSnapshot document) {
    /// The [entries] in my [Firestore] instance.
    List<dynamic> rawElements = document.data.entries.toList()[0].value;

    /// Those same [entries] but in a structured format- [DataBaseEntry].
    List<DataBaseEntry> parsedElements =
        new List<DataBaseEntry>.generate(rawElements.length, (int index) {
      return DataBaseEntry.buildFromMap(rawElements[index]);
    });
    return parsedElements;
  }

  Future<void> _refreshList() async {
    final int currentId = currentData.id;
    String path = Constants.competitionsText.toLowerCase();
    CollectionReference reference = Firestore.instance.collection(path);
    Future<QuerySnapshot> newData = reference.snapshots().first;

    setState(() {
      newData.then((QuerySnapshot snapshot) {
        DocumentSnapshot document = snapshot.documents[0];
        List<DataBaseEntry> parsedOutput = _getDataBaseEntries(document);

        for (DataBaseEntry entry in parsedOutput) {
          if (entry.id == currentId) {
            this.currentData = entry;
            break;
          }
        }
      });
    });
  }

  bool _applyPrivileges(String codeAttempt) {
    if (codeAttempt == currentData.id.toString()) {
      final preferences = SharedPreferences.getInstance();
      preferences.then((SharedPreferences preferences) {
        preferences.setString(
            Constants.activeCompetitionText, currentData.id.toString());
      });
      return true;
    }
    return false;
  }

  RefreshIndicator _getRefreshIndicator() {
    return RefreshIndicator(
      displacement: 80.0,
      color: Constants.accentAppColor,
      backgroundColor: Constants.primaryAppColor,
      child: OpacityChangeWidget(
          target: ListView.builder(
        itemBuilder: _tileBuilder,
        itemCount: currentData.holes.length + 1,
      )),
      onRefresh: _refreshList,
    );
  }

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
      body: _getRefreshIndicator(),
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
