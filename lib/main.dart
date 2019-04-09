import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_resources.dart';
import 'package:howth_golf_live/pages/apphelp_page.dart';
import 'package:howth_golf_live/pages/clublinks_page.dart';
import 'package:howth_golf_live/pages/home_page.dart';
import 'package:howth_golf_live/pages/results_page.dart';
import 'package:howth_golf_live/pages/competitions_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget with AppResources {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: constants.appName,
        theme: appTheme,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => HomePage(),
          '/' + constants.competitionsText: (context) => CompetitionsPage(),
          '/' + constants.resultsText: (context) => ResultsPage(),
          '/' + constants.clubLinksText: (context) => ClubLinksPage(),
          '/' + constants.appHelpText: (context) => AppHelpPage(),
        });
  }
}
