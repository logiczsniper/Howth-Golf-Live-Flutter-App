import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/list_tile.dart';
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
  static Card _getCard(Widget child) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 1.85,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: Constants.roundedRectBoxDecoration, child: child));
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
    List<HelpStep> steps = widget.entry.steps;
    if (index == steps.length) {
      return Padding(
          child: Icon(
            Icons.check,
            color: Constants.primaryAppColorDark,
          ),
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 25.0));
    }

    HelpStep currentStep = steps[index];
    return _getCard(Container(
        decoration: Constants.roundedRectBoxDecoration,
        child: BaseListTile(
          leadingChild: _getLeadingColumn("STEP", (index + 1).toString()),
          trailingWidget: null,
          subtitleText: currentStep.data,
          subtitleMaxLines: 4,
          titleText: currentStep.title,
          threeLine: true,
        )));
  }

  Text _getTitle() {
    return Text(widget.entry.title,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyle(
          color: Constants.primaryAppColorDark,
        ));
  }

  void _toCompetitions() {
    final preferences = SharedPreferences.getInstance();
    preferences.then((SharedPreferences preferences) {
      Navigator.pushNamed(context, '/' + Constants.competitionsText,
          arguments: Privileges.buildFromPreferences(preferences));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _getTitle(),
          backgroundColor: Constants.primaryAppColor,
          iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              tooltip: 'Tap to return to home!',
              onPressed: _toCompetitions,
              color: Constants.primaryAppColorDark,
            )
          ],
        ),
        body: ListView.builder(
          itemBuilder: _tileBuilder,
          itemCount: widget.entry.steps.length + 1,
        ),
        backgroundColor: Constants.primaryAppColor);
  }
}
