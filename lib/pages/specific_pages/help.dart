import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecificHelpPage extends StatefulWidget {
  final AppHelpEntry entry;

  SpecificHelpPage(this.entry);

  @override
  SpecificHelpPageState createState() => SpecificHelpPageState();
}

class SpecificHelpPageState extends State<SpecificHelpPage> {
  List<Widget> tileBuilder(BuildContext context) {
    List<HelpStep> steps = widget.entry.steps;
    List<Widget> output = [];
    for (HelpStep step in steps) {
      // TODO: this is insane- create custom builders for the list tile!!!
      // TODO: I find myself commenting about list tile widget builders- maybe a factory method for these??
      output.add(Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 1.85,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
              decoration: Constants.roundedRectBoxDecoration,
              child: ListTile(
                isThreeLine: true,
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
                              'STEP',
                              style: Constants.cardSubTitleTextStyle
                                  .apply(fontSizeDelta: -1.5),
                            ),
                            Text((steps.indexOf(step) + 1).toString(),
                                style: TextStyle(
                                    fontSize: 21.5,
                                    color: Constants.primaryAppColorDark,
                                    fontWeight: FontWeight.w400))
                          ]),
                    )),
                title: Text(
                  step.title,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: Constants.cardTitleTextStyle,
                ),
                subtitle: Text(step.data,
                    overflow: TextOverflow.fade,
                    maxLines: 4,
                    style: Constants.cardSubTitleTextStyle),
              ))));
    }
    output.add(Padding(
      child: Icon(
        Icons.check,
        color: Constants.primaryAppColorDark,
      ),
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 25.0),
    ));
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: custom app bar... maybe another factory method for app bars?
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.entry.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: Constants.primaryAppColorDark,
            )),
        backgroundColor: Constants.primaryAppColor,
        iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            tooltip: 'Tap to return to home!',
            onPressed: () {
              final preferences = SharedPreferences.getInstance();
              preferences.then((SharedPreferences preferences) {
                Navigator.pushNamed(context, '/' + Constants.competitionsText,
                    arguments: Privileges.buildFromPreferences(preferences));
              });
            },
            color: Constants.primaryAppColorDark,
          )
        ],
        elevation: 0.0,
      ),
      body: ListView(
        children: tileBuilder(context),
      ),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
