import 'package:flutter/material.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class HelpPage extends StatelessWidget {
  final AppHelpEntry helpEntry;

  HelpPage(this.helpEntry);

  /// Converts each of the [HelpStep]s into suitable [ListTile]s.
  Widget _tileBuilder(BuildContext context, int index) {
    List<HelpStep> steps = helpEntry.steps;
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
                style: TextStyles.cardTitle,
                textAlign: TextAlign.left,
              ),
              padding: EdgeInsets.only(bottom: 5.0)),
          Padding(
              child: Text(
                currentStep.data,
                style: TextStyles.cardSubTitle,
              ),
              padding: EdgeInsets.only(left: 4.5))
        ],
      ),
    );
  }

  Text get _title => Text(helpEntry.title,
      textAlign: TextAlign.center, maxLines: 2, style: TextStyles.helpTitle);

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
          itemCount: helpEntry.steps.length + 1,
          separatorBuilder: (context, index) {
            return index != helpEntry.steps.length - 1
                ? Divider()
                : Container();
          }),
    );
  }
}
