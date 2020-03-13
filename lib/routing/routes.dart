import 'package:flutter/material.dart';

import 'package:howth_golf_live/app/competitions/competitions_page.dart';
import 'package:howth_golf_live/app/competitions/competition_page.dart';
import 'package:howth_golf_live/app/creation/create_competition.dart';
import 'package:howth_golf_live/app/creation/create_hole.dart';
import 'package:howth_golf_live/app/help/help_page.dart';
import 'package:howth_golf_live/app/help/helps_page.dart';
import 'package:howth_golf_live/app/hole/hole_page.dart';
import 'package:howth_golf_live/app/home/home_page.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';

Widget get homePage => HomePage();
Widget get competitionsPage => CompetitionsPage();
Widget get helpsPage => HelpsPage();

class Routes {
  /// The initial route.
  static String get home => "/";

  /// Push to [destination].
  static void pushTo(BuildContext context, Widget destination) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => destination));

  /// Push to [CreateCompetition] page.
  static void toCompetitionCreation(BuildContext context) =>
      pushTo(context, CreateCompetition());

  /// Push to the [CreateHole] page.
  static void toHoleCreation(BuildContext context, int id) =>
      pushTo(context, CreateHole(id));

  /// Push to the [Help] page.
  static void toHelp(BuildContext context, AppHelpEntry helpEntry) =>
      pushTo(context, HelpPage(helpEntry));

  /// Push to the [Hole] page.
  static void toHole(BuildContext context, int id, int index) =>
      pushTo(context, HolePage(id, index - 2));

  /// Push to the [Competition] page.
  static void toCompetition(BuildContext context, DatabaseEntry currentEntry) =>
      pushTo(context, CompetitionPage(currentEntry));

  /// A simple mapping of title to a page within the app for readablity.
  static Map<String, Widget Function(BuildContext)> get map => {
        home: (context) => homePage,
        home + Strings.competitionsText: (context) => competitionsPage,
        home + Strings.helpsText: (context) => helpsPage,
      };
}
