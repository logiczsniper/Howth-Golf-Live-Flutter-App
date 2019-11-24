import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/list_tile.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:howth_golf_live/static/objects.dart';

class SpecificHelpPage extends StatefulWidget {
  final AppHelpEntry entry;

  SpecificHelpPage(this.entry);

  @override
  SpecificHelpPageState createState() => SpecificHelpPageState();
}

class SpecificHelpPageState extends State<SpecificHelpPage> {
  Widget _tileBuilder(BuildContext context, int index) {
    List<HelpStep> steps = widget.entry.steps;
    if (index == steps.length) {
      return Padding(
          child: Icon(
            Icons.check,
            color: Toolkit.primaryAppColorDark,
          ),
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 25.0));
    }

    HelpStep currentStep = steps[index];
    return Toolkit.getCard(Container(
        decoration: Toolkit.roundedRectBoxDecoration,
        child: BaseListTile(
          leadingChild:
              Toolkit.getLeadingColumn("STEP", (index + 1).toString()),
          trailingIconData: null,
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
          color: Toolkit.primaryAppColorDark,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _getTitle(),
          backgroundColor: Toolkit.primaryAppColor,
          iconTheme: IconThemeData(color: Toolkit.primaryAppColorDark),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              tooltip: 'Tap to return to home!',
              onPressed: () =>
                  Toolkit.navigateTo(context, Toolkit.competitionsText),
              color: Toolkit.primaryAppColorDark,
            )
          ],
        ),
        body: ListView.builder(
          itemBuilder: _tileBuilder,
          itemCount: widget.entry.steps.length + 1,
        ),
        backgroundColor: Toolkit.primaryAppColor);
  }
}
