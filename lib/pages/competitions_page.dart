import 'package:flutter/material.dart';
import 'package:howth_golf_live/app_resources.dart';
import 'package:dio/dio.dart';

class CompetitionsPage extends StatefulWidget with AppResources {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.competitionsText;
  }

  @override
  _CompetitionsPageState createState() => new _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> with AppResources {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
                drawer: elementBuilder.buildDrawer(context),
                appBar: elementBuilder.buildTabAppBar(
                    context, constants.competitionsText),
                body: TabBarView(
                  children: <Widget>[
                    Text('Tournaments now!'),
                    Text('Archived tournaments!'),
                    Text('Your favourite tournaments!')
                  ],
                ))));
  }
}
