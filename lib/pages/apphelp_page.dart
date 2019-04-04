import 'package:flutter/material.dart';
import 'package:howth_golf_live/app_resources.dart';

class AppHelpPage extends StatelessWidget with AppResources {
  AppHelpPage({Key key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.appHelpText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: elementBuilder.buildDrawer(context),
        appBar: elementBuilder.buildAppBar(context, 'App Help'),
        body: Center(child: Text('App Help page')));
  }
}
