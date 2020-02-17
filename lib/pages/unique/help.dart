import 'package:flutter/material.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class SpecificHelpPage extends StatefulWidget {
  final AppHelpEntry entry;

  SpecificHelpPage(this.entry);

  @override
  SpecificHelpPageState createState() => SpecificHelpPageState();
}

class SpecificHelpPageState extends State<SpecificHelpPage> {
  /// Converts each of the [HelpStep]s into suitable [ListTile]s.
  Widget _tileBuilder(BuildContext context, int index) {
    List<HelpStep> steps = widget.entry.steps;
    if (index == steps.length)
      return Padding(
          child: Icon(
            Icons.check,
            color: Palette.maroon,
          ),
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 25.0));

    HelpStep currentStep = steps[index];

    return Container(
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.all(2.0),
      child: Column(
        children: <Widget>[
          Padding(
              child: Text(
                currentStep.title,
                style: UIToolkit.cardTitleTextStyle,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.only(bottom: 3.0)),
          Padding(
              child: Text(
                currentStep.data,
                style: UIToolkit.cardSubTitleTextStyle,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.only(left: 4.5))
        ],
      ),
    );
  }

  Text get _title => Text(widget.entry.title,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: UIToolkit.titleTextStyle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _title,
          actions: <Widget>[UIToolkit.getHomeButton(context)],
        ),
        body: ListView.separated(
            itemBuilder: _tileBuilder,
            itemCount: widget.entry.steps.length + 1,
            separatorBuilder: (context, index) {
              return index != widget.entry.steps.length - 1
                  ? Divider(
                      thickness: 1.5,
                      color: Palette.maroon,
                      indent: 70.0,
                      endIndent: 70.0,
                      height: 25.0,
                    )
                  : Container();
            }),
        backgroundColor: Palette.light);
  }
}
