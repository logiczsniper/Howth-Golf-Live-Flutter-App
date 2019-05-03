import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/pages/apphelp.dart';
import 'package:howth_golf_live/pages/clublinks.dart';
import 'package:howth_golf_live/pages/home.dart';
import 'package:howth_golf_live/pages/results.dart';
import 'package:howth_golf_live/pages/competitions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Constants.appName,
        theme: Constants.appTheme,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => HomePage(),
          '/' + Constants.competitionsText: (context) => CompetitionsPage(),
          '/' + Constants.resultsText: (context) => ResultsPage(),
          '/' + Constants.clubLinksText: (context) => ClubLinksPage(),
          '/' + Constants.appHelpText: (context) => AppHelpPage(),
        });
  }
}
