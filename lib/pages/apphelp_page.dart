import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_bar_custom.dart';
import 'package:howth_golf_live/static/app_drawer.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class AppHelpPage extends StatelessWidget with AppResources {
  AppHelpPage({Key key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.appHelpText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: StandardAppBar(constants.appHelpText),
      body: Center(child: Text('App Help page')),
      backgroundColor: appTheme.primaryColor,
    );
  }
}
