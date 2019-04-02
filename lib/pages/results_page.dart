import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants.dart';
import 'package:howth_golf_live/element_builder.dart';

class ResultsPage extends StatefulWidget {

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return Constants().resultsText;
  }

  @override
  _ResultsPageState createState() => new _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final Constants clubConstants = Constants();
  final ElementBuilder elementBuilder = ElementBuilder();

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
