import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants.dart';
import 'package:howth_golf_live/element_builder.dart';

class TournamentsPage extends StatefulWidget {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return Constants().competitionsText;
  }

  @override
  _TournamentsPageState createState() => new _TournamentsPageState();
}

class _TournamentsPageState extends State<TournamentsPage> {
  final Constants clubConstants = Constants();
  final ElementBuilder elementBuilder = ElementBuilder();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                drawer: elementBuilder.buildDrawer(context),
                appBar: elementBuilder.buildTabAppBar(
                    context, Constants().competitionsText),
                body: TabBarView(
                  children: <Widget>[
                    Text('Tournaments now!'),
                    Text('Archived tournaments!'),
                    Text('Your favourite tournaments!')
                  ],
                ))));
  }
}
