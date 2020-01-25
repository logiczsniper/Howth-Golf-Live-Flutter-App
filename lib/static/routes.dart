import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/competitions.dart';
import 'package:howth_golf_live/pages/app_help.dart';
import 'package:howth_golf_live/pages/home.dart';
import 'package:howth_golf_live/static/toolkit.dart';

Widget get homePage => HomePage();
Widget get competitionsPage => CompetitionsPage();
Widget get helpPage => HelpPage();

class Routes {
  /// A simple mapping of title to a page within the app for readablity.
  static Map<String, Widget Function(BuildContext)> get map => {
        Toolkit.home: (context) => homePage,
        Toolkit.home + Toolkit.competitionsText: (context) => competitionsPage,
        Toolkit.home + Toolkit.helpText: (context) => helpPage,
      };
}
