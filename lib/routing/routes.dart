import 'package:flutter/material.dart';

import 'package:howth_golf_live/app/competitions/competitions_page.dart';
import 'package:howth_golf_live/app/competitions/competition_page.dart';
import 'package:howth_golf_live/app/creation/create_competition.dart';
import 'package:howth_golf_live/app/creation/create_hole.dart';
import 'package:howth_golf_live/app/help/help_page.dart';
import 'package:howth_golf_live/app/help/helps_page.dart';
import 'package:howth_golf_live/app/hole/hole_page.dart';
import 'package:howth_golf_live/app/home/home_page.dart';
import 'package:howth_golf_live/app/modification/modify_competition.dart';
import 'package:howth_golf_live/app/modification/modify_hole.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';

Widget get homePage => HomePage();
Widget get competitionsPage => CompetitionsPage();
Widget get helpsPage => HelpsPage();

class Routes {
  /// The initial route.
  static String get home => "/";

  BuildContext context;
  Routes(this.context);
  Routes.of(BuildContext context) : context = context;

  /// Push to [destination].
  void pushTo(Widget destination) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => destination));

  /// Push to [ModifyCompetition] page.
  void toCompetitionModification(DatabaseEntry currentEntry) =>
      pushTo(ModifyCompetition(currentEntry));

  /// Push to [ModifyHole] page.
  void toHoleModification(int id, int index, Hole currentHole) =>
      pushTo(ModifyHole(id, index, currentHole));

  /// Push to [CreateCompetition] page.
  void toCompetitionCreation() => pushTo(CreateCompetition());

  /// Push to the [CreateHole] page.
  void toHoleCreation(int id) => pushTo(CreateHole(id));

  /// Push to the [Helps] page.
  void toHelps() => pushTo(HelpsPage());

  /// Push to the [Help] page.
  void toHelp(AppHelpEntry helpEntry) => pushTo(HelpPage(helpEntry));

  /// Push to the [Hole] page.
  void toHole(int id, int index) => pushTo(HolePage(id, index - 2));

  /// Push to [Competitions] page.
  void toCompetitions() => pushTo(CompetitionsPage());

  /// Push to the [Competition] page.
  void toCompetition(DatabaseEntry currentEntry) =>
      pushTo(CompetitionPage(currentEntry));

  /// A simple mapping of title to a page within the app for readablity.
  static Map<String, Widget Function(BuildContext)> get map => {
        home: (context) => homePage,
        home + Strings.competitionsText: (context) => competitionsPage,
        home + Strings.helpsText: (context) => helpsPage,
      };
}
