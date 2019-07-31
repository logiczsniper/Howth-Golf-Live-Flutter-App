import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/custom_elements/competition_details_widgets/competition_details.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/opacity_change.dart';
import 'package:howth_golf_live/custom_elements/floating_action_button.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecificCompetitionPage extends StatefulWidget {
  final DataBaseEntry competition;
  final bool hasAccess;

  SpecificCompetitionPage(this.competition, this.hasAccess);

  @override
  SpecificCompetitionPageState createState() => SpecificCompetitionPageState();
}

class SpecificCompetitionPageState extends State<SpecificCompetitionPage> {
  DataBaseEntry currentData;

  String formatPlayerList(List playerList) {
    String output = '';
    for (String player in playerList) {
      output += player.toString();
      if (playerList.indexOf(player) != playerList.length - 1) {
        output += ', ';
      }
    }
    return output;
  }

  List tilesBuilder(BuildContext context) {
    List<Widget> output = [CompetitionDetails(currentData)];

    for (Hole hole in currentData.holes) {
      IconData trailingIcon;
      if (hole.holeScore.toLowerCase().contains('up')) {
        trailingIcon = Icons.thumb_up;
      } else if (hole.holeScore.toLowerCase().contains('under')) {
        trailingIcon = Icons.thumb_down;
      } else {
        trailingIcon = Icons.thumbs_up_down;
      }
      output.add(Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 1.85,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
              decoration: Constants.roundedRectBoxDecoration,
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
                  leading: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Container(
                        padding: EdgeInsets.only(right: 15.0),
                        decoration: Constants.rightSideBoxDecoration,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'HOLE',
                                style: Constants.cardSubTitleTextStyle
                                    .apply(fontSizeDelta: -1.5),
                              ),
                              Text(hole.holeNumber.toString(),
                                  style: TextStyle(
                                      fontSize: 21.5,
                                      color: Constants.primaryAppColorDark,
                                      fontWeight: FontWeight.w400))
                            ]),
                      )),
                  title: Text(
                    hole.holeScore,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: Constants.cardTitleTextStyle,
                  ),
                  subtitle: Text(formatPlayerList(hole.players),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: Constants.cardSubTitleTextStyle),
                  trailing: OpacityChangeWidget(
                      target: Icon(trailingIcon,
                          color: Constants.primaryAppColorDark,
                          size: 19.0))))));
    }
    return output;
  }

  Future<void> refreshList() async {
    final int currentId = currentData.id;
    Future<QuerySnapshot> newData = Firestore.instance
        .collection(Constants.competitionsText.toLowerCase())
        .snapshots()
        .first;
    setState(() {
      newData.then((QuerySnapshot snapshot) {
        List<dynamic> databaseOutput =
            snapshot.documents[0].data.entries.toList()[0].value;
        List<DataBaseEntry> parsedOutput = [];
        databaseOutput.forEach((dynamic map) {
          parsedOutput.add(DataBaseEntry.buildFromMap(map));
        });

        for (DataBaseEntry entry in parsedOutput) {
          if (entry.id == currentId) {
            this.currentData = entry;
            break;
          }
        }
      });
    });
  }

  bool applyPrivileges(String codeAttempt) {
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

  /// TODO build out method
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
          CodeFieldBar(currentData.title, applyPrivileges, widget.hasAccess),
      body: RefreshIndicator(
        displacement: 50.0,
        color: Constants.accentAppColor,
        backgroundColor: Constants.primaryAppColor,
        child: ListView(
          children: tilesBuilder(context),
        ),
        onRefresh: refreshList,
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Constants.primaryAppColor,
    );
  }
}