import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:howth_golf_live/custom_elements/app_bars/competitions_bar.dart';
import 'package:howth_golf_live/custom_elements/complex_card.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/fading_element.dart';
import 'package:howth_golf_live/pages/specific_pages/competition.dart';
import 'package:howth_golf_live/static/constants.dart';

class CompetitionsPage extends StatefulWidget {
  @override
  _CompetitionsPageState createState() => new _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> {
  static Widget tileBuilder(int index, List filteredElements) {
    var base = filteredElements[index];
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
        leading: Padding(
            padding: EdgeInsets.only(top: 4),
            child: Container(
              padding: EdgeInsets.only(right: 15.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(
                          width: 1.5, color: Constants.accentAppColor))),
              child: Text(
                  "${base['score']['howth']} - ${base['score']['opposition']}",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 20,
                      color: Constants.primaryAppColorDark,
                      fontWeight: FontWeight.w400)),
            )),
        title: Text(
          "${base['title']}",
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Constants.cardTitleTextStyle,
        ),
        subtitle: Text("${base['date']}",
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: Constants.cardSubTitleTextStyle),
        trailing: FadingElement(
          Icon(Icons.keyboard_arrow_right,
              color: Constants.primaryAppColorDark),
          false,
          duration: Duration(milliseconds: 800),
        ));
  }

  Widget _complexTileBuilder(int index, List filteredElements) {
    if (filteredElements == null)
      return ListTile(
          title: Center(
              child: SpinKitPulse(
        color: Constants.primaryAppColorDark,
        size: 45,
        duration: Duration(milliseconds: 800),
      )));

    if (filteredElements[0] is bool)
      return ListTile(
          title: Center(
              child: Text(
                  "No ${Constants.competitionsText.toLowerCase()} found!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontWeight: FontWeight.w300))));

    return tileBuilder(index, filteredElements);
  }

  Widget _buildElementsList(String _searchText, {bool current = false}) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(Constants.competitionsText.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: SpinKitPulse(
              color: Constants.primaryAppColorDark,
            ));

          var elements =
              snapshot.data.documents[0].data.entries.toList()[0].value;

          List filteredElements = elements;

          if (_searchText.isNotEmpty) {
            List tempList = new List();
            for (int i = 0; i < elements.length; i++) {
              if (elements[i]
                  .values
                  .join()
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
                tempList.add(elements[i]);
              }
            }
            filteredElements = tempList.isNotEmpty ? tempList : [];
          }

          List<Map> currentElements = [];
          List<Map> archivedElements = [];
          List<Map> activeElements =
              current ? currentElements : archivedElements;
          for (Map filteredElement in filteredElements) {
            DateTime competitionDate = DateTime.parse(filteredElement['date']
                    .toString()
                    .split('/')
                    .reversed
                    .join()
                    .replaceAll('/', '-') +
                ' 00:00:00');
            if ((competitionDate.difference(DateTime.now()).inDays.abs() < 7 &&
                    competitionDate.isBefore(DateTime.now())) ||
                competitionDate.isAfter(DateTime.now())) {
              currentElements.add(filteredElement);
            } else {
              archivedElements.add(filteredElement);
            }
          }

          return ListView.builder(
            itemCount: activeElements.length,
            itemBuilder: (BuildContext context, int index) {
              return ComplexCard(_complexTileBuilder(index, activeElements),
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SpecificCompetitionPage(activeElements[index])));
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: CompetitionsPageAppBar(_buildElementsList,
              title: Constants.competitionsText)),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
