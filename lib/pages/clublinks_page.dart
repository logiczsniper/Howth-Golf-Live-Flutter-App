import 'package:flutter/material.dart';
import 'package:howth_golf_live/element_builder.dart';
import 'package:howth_golf_live/constants.dart';

class ClubLinksPage extends StatelessWidget {
  final ElementBuilder elementBuilder = ElementBuilder();
  final Constants constants = Constants();

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
