import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/custom_elements/competition_details.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/fading_element.dart';
import 'package:howth_golf_live/static/constants.dart';

class SpecificCompetitionPage extends StatefulWidget {
  final Map competition;

  SpecificCompetitionPage(this.competition);

  @override
  SpecificCompetitionPageState createState() => SpecificCompetitionPageState();
}

class SpecificCompetitionPageState extends State<SpecificCompetitionPage> {
  Map currentData;

  @override
  initState() {
    super.initState();
    Map currentData = widget.competition;
  }

  String processPlayerList(List playerList) {
    String output = '';
    for (String player in playerList) {
      output += player.toString();
      if (playerList.indexOf(player) != playerList.length - 1) {
        output += ', ';
      }
    }
    return output;
  }

  List tileBuilder(BuildContext context) {
    List holes = widget.competition['holes'];
    List<Widget> output = [CompetitionDetails(widget.competition)];
    for (Map hole in holes) {
      IconData trailingIcon;
      if (hole['hole_score'].toString().toLowerCase().contains('up')) {
        trailingIcon = Icons.thumb_up;
      } else if (hole['hole_score']
          .toString()
          .toLowerCase()
          .contains('under')) {
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
              decoration: BoxDecoration(
                  color: Constants.cardAppColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
                leading: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Container(
                      padding: EdgeInsets.only(right: 15.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.5,
                                  color: Constants.accentAppColor))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'HOLE',
                              style: Constants.cardSubTitleTextStyle
                                  .apply(fontSizeDelta: -1.5),
                            ),
                            Text(hole['hole_number'].toString(),
                                style: TextStyle(
                                    fontSize: 21.5,
                                    color: Constants.primaryAppColorDark,
                                    fontWeight: FontWeight.w400))
                          ]),
                    )),
                title: Text(
                  "${hole['hole_score']}",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: Constants.cardTitleTextStyle,
                ),
                subtitle: Text(processPlayerList(hole['players']),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: Constants.cardSubTitleTextStyle),
                trailing: FadingElement(
                  Icon(trailingIcon,
                      color: Constants.primaryAppColorDark, size: 19.0),
                  false,
                  duration: Duration(milliseconds: 800),
                ),
              ))));
    }
    return output;
  }

  Future<void> refreshList() async {
    final int currentId = widget.competition['id'];
    Future<QuerySnapshot> newData = Firestore.instance
        .collection(Constants.competitionsText.toLowerCase())
        .snapshots()
        .first;
    setState(() {
      newData.then((QuerySnapshot snapshot) {
        this.currentData =
            snapshot.documents[0].data.entries.toList()[0].value[currentId];
      });
      // TODO fix me
    });
  }

  void applyPrivileges(String codeAttempt) {
    if (codeAttempt == widget.competition['id'].toString()) {
      // TODO
      print('apply competition priviliges');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CodeFieldBar(widget.competition, applyPrivileges),
      body: RefreshIndicator(
        displacement: 50.0,
        color: Constants.accentAppColor,
        backgroundColor: Constants.primaryAppColor,
        child: ListView(
          children: tileBuilder(context),
        ),
        onRefresh: refreshList,
      ),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
