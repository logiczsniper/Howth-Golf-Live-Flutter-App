import 'package:flutter/material.dart';
import 'package:howth_golf_live/app_resources.dart';

class ClubLinksPage extends StatelessWidget with AppResources {
  ClubLinksPage({Key key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.clubLinksText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: elementBuilder.buildDrawer(context),
        appBar: elementBuilder.buildAppBar(context, constants.clubLinksText),
        body: Center(child: Text('Club Links page')));
  }
}
