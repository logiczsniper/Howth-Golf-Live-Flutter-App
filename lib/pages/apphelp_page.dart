import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants.dart';
import 'package:howth_golf_live/element_builder.dart';

class AppHelpPage extends StatelessWidget {
  final ElementBuilder elementBuilder = ElementBuilder();

  AppHelpPage({Key key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return Constants().appHelpText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: elementBuilder.buildDrawer(context),
        appBar: elementBuilder.buildAppBar(context, 'App Help'),
        body: Center(child: Text('App Help page')));
  }
}
