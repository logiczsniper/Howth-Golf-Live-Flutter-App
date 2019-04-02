import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/app_resources.dart';

class ResultsPage extends StatefulWidget with AppResources {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.resultsText;
  }

  @override
  _ResultsPageState createState() => new _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> with AppResources {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                drawer: elementBuilder.buildDrawer(context),
                appBar: elementBuilder.buildTabAppBar(context, 'Results'),
                body: TabBarView(
                  children: <Widget>[
                    Text('Recent results!'),
                    Text('Archived results!'),
                    Text('Your favourite results!')
                  ],
                ))));
  }
}
