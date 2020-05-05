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
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 25.0),
        child: Icon(
          Icons.check,
          color: Palette.maroon,
        ),
      );

    HelpStep currentStep = steps[index];

    return Container(
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.only(top: 5.0, bottom: 15.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                UIToolkit.getHoleNumberDecorated(
                    helpEntry.title == "App Usage - Q&A" ? "?" : index + 1),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      currentStep.title,
                      style: TextStyles.cardTitle
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.5),
            child: Text(
              currentStep.data,
              style: TextStyles.cardSubTitle,
            ),
          ),
        ],
      ),
    );
  }

  Text get _title => Text(
        helpEntry.title,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyles.title,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _title,
        leading: Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: IconButton(
            icon: BackButtonIcon(),
            onPressed: Navigator.of(context).pop,
          ),
        ),
        actions: <Widget>[
          Padding(
            child: UIToolkit.getHomeButton(context),
            padding: EdgeInsets.only(right: 16.0),
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: _tileBuilder,
        itemCount: helpEntry.steps.length + 1,
        padding: EdgeInsets.only(
          top: 10.0,
          right: 16.0,
          left: 16.0,
          bottom: 50.0,
        ),
      ),
    );
  }
}
