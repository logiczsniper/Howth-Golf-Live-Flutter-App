import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/pages/competitions.dart';
import 'package:howth_golf_live/pages/app_help.dart';
import 'package:howth_golf_live/pages/home.dart';

Widget get homePage => HomePage();
Widget get competitionsPage => CompetitionsPage();
Widget get helpPage => HelpPage();

class Routes {
  /// The initial route.
  static String get home => "/";

  /// A simple mapping of title to a page within the app for readablity.
  static Map<String, Widget Function(BuildContext)> get map => {
        home: (context) => homePage,
        home + Strings.competitionsText: (context) => competitionsPage,
        home + Strings.helpText: (context) => helpPage,
      };
}
