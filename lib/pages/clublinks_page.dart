import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_drawer.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class ClubLinksPage extends StatelessWidget with AppResources {
  ClubLinksPage({Key key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.clubLinksText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(constants.clubLinksText,
              style: TextStyle(color: appTheme.primaryColorDark)),
          backgroundColor: appTheme.primaryColor,
          iconTheme: IconThemeData(color: appTheme.primaryColorDark),
        ),
        body: Center(child: Text('Club Links page')));
  }
}
