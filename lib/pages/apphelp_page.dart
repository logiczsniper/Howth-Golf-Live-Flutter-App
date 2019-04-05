import 'package:flutter/material.dart';
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
        appBar: AppBar(
          centerTitle: true,
          title: Text(constants.appHelpText,
              style: TextStyle(color: appTheme.primaryColorDark)),
          backgroundColor: appTheme.primaryColor,
          iconTheme: IconThemeData(color: appTheme.primaryColorDark),
        ),
        body: Center(child: Text('App Help page')));
  }
}
