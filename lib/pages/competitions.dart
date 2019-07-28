import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:howth_golf_live/custom_elements/app_bars/competitions_bar.dart';
import 'package:howth_golf_live/custom_elements/complex_card.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/opacity_change.dart';
import 'package:howth_golf_live/custom_elements/floating_action_button.dart';
import 'package:howth_golf_live/pages/specific_pages/competition.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompetitionsPage extends StatefulWidget {
  @override
  _CompetitionsPageState createState() => new _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> {
  static Widget tileBuilder(
      BuildContext context,
      int index,
      List<DataBaseEntry> filteredElements,
      QuerySnapshot snapshot,
      List<dynamic> allElements) {
    DataBaseEntry base = filteredElements[index];
    final Privileges arguments = ModalRoute.of(context).settings.arguments;
    final bool isAdmin = arguments.isAdmin == null ? false : arguments.isAdmin;
    Widget trailingIcon = OpacityChangeWidget(
      target: isAdmin
          ? IconButton(
              icon: Icon(Icons.remove_circle_outline,
                  color: Constants.primaryAppColorDark),
              onPressed: () {
                /// TODO fix me the icon can not be pressed because the card itself is a button
                allElements.remove(base.convertToMap());
                List<Map> updatedData = allElements;
                snapshot.documents
                    .elementAt(0)
                    .reference
                    .updateData({'data': updatedData});
              },
            )
          : Icon(Icons.keyboard_arrow_right,
              color: Constants.primaryAppColorDark),
    );

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
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
        leading: Padding(
            padding: EdgeInsets.only(top: 4),
            child: Container(
              padding: EdgeInsets.only(right: 15.0),
              decoration: Constants.rightSideBoxDecoration,
              child: Text("${base.score.howth} - ${base.score.opposition}",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 20,
                      color: Constants.primaryAppColorDark,
                      fontWeight: FontWeight.w400)),
            )),
        title: Text(
          base.title,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Constants.cardTitleTextStyle,
        ),
        subtitle: Text(base.date,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: Constants.cardSubTitleTextStyle),
        trailing: trailingIcon);
  }

  Widget _buildElementsList(String _searchText, bool current) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(Constants.competitionsText.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return Center(
                child: Column(
              children: <Widget>[
                Icon(Icons.error, color: Constants.primaryAppColorDark),
                Text(
                  'Oof, please email the address in App Help to report this error.',
                  style: Constants.cardSubTitleTextStyle,
                )
              ],
            ));
          }

          if (!snapshot.hasData)
            return Center(
                child: SpinKitPulse(
              color: Constants.primaryAppColorDark,
            ));

          List<dynamic> allElements =
              snapshot.data.documents[0].data.entries.toList()[0].value;
          List<DataBaseEntry> elements = new List<DataBaseEntry>.generate(
              snapshot.data.documents[0].data.entries.toList()[0].value.length,
              (int index) {
            return DataBaseEntry.buildFromMap(snapshot
                .data.documents[0].data.entries
                .toList()[0]
                .value[index]);
          });

          List<DataBaseEntry> filteredElements = elements;

          if (_searchText.isNotEmpty) {
            List<DataBaseEntry> tempList = new List();
            for (int i = 0; i < elements.length; i++) {
              if (elements[i]
                  .values
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
                tempList.add(elements[i]);
              }
            }
            filteredElements = tempList.isNotEmpty ? tempList : [];
          }

          List<DataBaseEntry> currentElements = [];
          List<DataBaseEntry> archivedElements = [];
          List<DataBaseEntry> activeElements =
              current ? currentElements : archivedElements;
          for (DataBaseEntry filteredElement in filteredElements) {
            DateTime competitionDate = DateTime.parse(filteredElement.date
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

          /// TODO make this an animated list
          return ListView.builder(
            itemCount: activeElements.length,
            itemBuilder: (BuildContext context, int index) {
              return ComplexCard(
                  tileBuilder(context, index, activeElements, snapshot.data,
                      allElements), () {
                final preferences = SharedPreferences.getInstance();
                preferences.then((SharedPreferences preferences) {
                  final Privileges arguments =
                      ModalRoute.of(context).settings.arguments;
                  final bool isAdmin =
                      arguments.isAdmin == null ? false : arguments.isAdmin;
                  final bool isManager = arguments.competitionAccess ==
                          activeElements[index].id.toString()
                      ? true
                      : false;
                  final bool hasAccess = isAdmin || isManager;

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpecificCompetitionPage(
                              activeElements[index], hasAccess)));
                });
              });
            },
          );
        });
  }

  /// TODO build out method
  void addCompetition() {}

  @override
  Widget build(BuildContext context) {
    final Privileges arguments = ModalRoute.of(context).settings.arguments;
    final bool isAdmin = arguments.isAdmin == null ? false : arguments.isAdmin;

    MyFloatingActionButton floatingActionButton = isAdmin
        ? MyFloatingActionButton(
            onPressed: addCompetition, text: 'Add a Competition')
        : null;
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: CompetitionsPageAppBar(_buildElementsList,
              title: Constants.competitionsText)),
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
