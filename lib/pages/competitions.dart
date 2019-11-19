import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:howth_golf_live/custom_elements/app_bars/competitions_bar.dart';
import 'package:howth_golf_live/custom_elements/complex_card.dart';
import 'package:howth_golf_live/custom_elements/opacity_change.dart';
import 'package:howth_golf_live/custom_elements/buttons/floating_action_button.dart';

import 'package:howth_golf_live/pages/create_competition.dart';
import 'package:howth_golf_live/pages/specific_pages/competition.dart';

import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';

class CompetitionsPage extends StatefulWidget {
  @override
  _CompetitionsPageState createState() => new _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> {
  // TODO: create getters and setters for all these params, set them in the method that calls tileBuilder (which is also in this class)
  static Widget tileBuilder(
      BuildContext context,
      int index,
      List<DataBaseEntry> filteredElements,
      QuerySnapshot snapshot,
      List<dynamic> allElements) {
    DataBaseEntry currentEntry = filteredElements[index];
    final Privileges arguments = ModalRoute.of(context).settings.arguments;
    final bool isAdmin = arguments.isAdmin == null ? false : arguments.isAdmin;

    // TODO: make function to check filteredElements
    if (filteredElements == null)
      return ListTile(
          title: Center(
              child: SpinKitPulse(
        color: Constants.primaryAppColorDark,
        size: 45,
        duration: Duration(milliseconds: 850),
      )));

    if (filteredElements[0] is bool)
      return ListTile(
          title: Center(
              child: Text(
                  "No ${Constants.competitionsText.toLowerCase()} found!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Constants.primaryAppColorDark,
                      fontWeight: FontWeight.w300))));

    // TODO: create methods to build each of these (leading, title, subtitle, etc), passing in the variant as parameter.
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
      leading: Padding(
          padding: EdgeInsets.only(top: 4),
          child: Container(
            padding: EdgeInsets.only(right: 15.0),
            decoration: Constants.rightSideBoxDecoration,
            child: Text(
                "${currentEntry.score.howth} - ${currentEntry.score.opposition}",
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 20,
                    color: Constants.primaryAppColorDark,
                    fontWeight: FontWeight.w400)),
          )),
      title: Text(
        currentEntry.title,
        overflow: TextOverflow.fade,
        maxLines: 1,
        style: Constants.cardTitleTextStyle,
      ),
      subtitle: Text(currentEntry.date,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Constants.cardSubTitleTextStyle),
      trailing: isAdmin
          ? null
          : Icon(Icons.keyboard_arrow_right,
              color: Constants.primaryAppColorDark),
    );
  }

  Widget _buildElementsList(String _searchText, bool isCurrentTab) {
    return OpacityChangeWidget(
        target: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(Constants.competitionsText.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              // TODO: extract the following two if statements to check snapshot validity.
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

              // TODO: sort out following few definitions
              List<dynamic> allElements =
                  snapshot.data.documents[0].data.entries.toList()[0].value;
              List<DataBaseEntry> elements = new List<DataBaseEntry>.generate(
                  snapshot.data.documents[0].data.entries
                      .toList()[0]
                      .value
                      .length, (int index) {
                return DataBaseEntry.buildFromMap(snapshot
                    .data.documents[0].data.entries
                    .toList()[0]
                    .value[index]);
              });

              List<DataBaseEntry> filteredElements = elements;

              if (_searchText.isNotEmpty) {
                List<DataBaseEntry> tempList = new List();
                for (int i = 0; i < elements.length; i++) {
                  // TODO: create variable to make conditional more readable.
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
                  isCurrentTab ? currentElements : archivedElements;
              for (DataBaseEntry filteredElement in filteredElements) {
                // TODO: extract method to parse competition date
                DateTime competitionDate = DateTime.parse(filteredElement.date
                        .toString()
                        .split('/')
                        .reversed
                        .join()
                        .replaceAll('/', '-') +
                    ' 00:00:00');
                // TODO: create variables to make this conditional more readable.
                if ((competitionDate.difference(DateTime.now()).inDays.abs() <
                            7 &&
                        competitionDate.isBefore(DateTime.now())) ||
                    competitionDate.isAfter(DateTime.now())) {
                  currentElements.add(filteredElement);
                } else {
                  archivedElements.add(filteredElement);
                }
              }

              // TODO: clean this up, these lines occur higher up in program
              final Privileges arguments =
                  ModalRoute.of(context).settings.arguments;
              final bool isAdmin =
                  arguments.isAdmin == null ? false : arguments.isAdmin;

              return ListView.builder(
                itemCount: activeElements.length,
                itemBuilder: (BuildContext context, int index) {
                  return ComplexCard(
                      tileBuilder(context, index, activeElements, snapshot.data,
                          allElements), () {
                    // TODO: extract methods here to clean up
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
                  },
                      iconButton: isAdmin
                          ? IconButton(
                              icon: Icon(Icons.remove_circle_outline,
                                  color: Constants.primaryAppColorDark),
                              onPressed: () {
                                showAlertDialog(context, allElements,
                                    activeElements, index, snapshot);
                              },
                            )
                          : null);
                },
              );
            }));
  }

  // TODO: create dialogParams class to pass parameters
  showAlertDialog(
      BuildContext context,
      List allElements,
      List<DataBaseEntry> activeElements,
      int index,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Are you sure?", style: Constants.cardTitleTextStyle),
      content: Text("This action is irreversible.",
          style: Constants.cardSubTitleTextStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed: () {
            Navigator.of(context).pop();

            DocumentSnapshot documentSnapshot =
                snapshot.data.documents.elementAt(0);

            // TODO: extract competition deletion method.
            var dataBaseEntries =
                new List<dynamic>.from(documentSnapshot.data['data']);

            dataBaseEntries.removeWhere(
                (rawEntry) => predicate(rawEntry, activeElements, index));

            Map<String, dynamic> newData = {'data': dataBaseEntries};

            print(newData.runtimeType);
            documentSnapshot.reference.updateData(newData);
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  // TODO: rename!!!!!! >:(
  bool predicate(Map rawEntry, activeElements, index) {
    DataBaseEntry parsedEntry = DataBaseEntry.buildFromMap(rawEntry);

    if (activeElements[index].values == parsedEntry.values) {
      return true;
    }
    return false;
  }

  void addCompetition() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateCompetition()));
  }

  @override
  Widget build(BuildContext context) {
    final Privileges arguments = ModalRoute.of(context).settings.arguments;
    final bool isAdmin = arguments.isAdmin == null ? false : arguments.isAdmin;

    // TODO: extract to getActionButton
    MyFloatingActionButton floatingActionButton = isAdmin
        ? MyFloatingActionButton(
            onPressed: addCompetition, text: 'Add a Competition')
        : null;
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: CompetitionsPageAppBar(_buildElementsList,
              title: Constants.competitionsText)),
      // TODO: include in above TODO
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0), child: floatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Constants.primaryAppColor,
    );
  }

  // TODO: is redundant???
  void removeCurrentElement(
      DocumentSnapshot documentSnapshot, Map convertToMap) {
    List databaseEntries = documentSnapshot.data['data'];

    for (var entry in databaseEntries) {
      DataBaseEntry parsedEntry = DataBaseEntry.buildFromMap(entry);
    }
  }

  // TODO: organise class! sort methods in some order!
}
