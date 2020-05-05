import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'package:howth_golf_live/app/competitions/competitions_page.dart';
import 'package:howth_golf_live/app/competitions/competition_page.dart';
import 'package:howth_golf_live/app/help/help_page.dart';
import 'package:howth_golf_live/app/help/helps_page.dart';
import 'package:howth_golf_live/app/home/home_page.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/widgets/long_material_page_route.dart';

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
  void pushTo(Widget destination,
          {FutureOr<dynamic> Function(dynamic) onComplete}) =>
      Navigator.push(
        context,
        LongMaterialPageRoute(
          builder: (context) => ShowCaseWidget(
            builder: Builder(builder: (_) => destination),
            onFinish: () {
              var _userStatus =
                  Provider.of<UserStatusViewModel>(context, listen: false);

              String route;

              switch (destination.runtimeType) {
                case CompetitionsPage:
                  route = Strings.competitionsText;
                  break;
                case HelpsPage:
                  route = Strings.helpsText;
                  break;
                case CompetitionPage:
                  route = Strings.specificCompetition;
                  break;
                default:
                  route = Strings.empty;
              }

              /// Visit the route in [UserStatusViewModel].
              if (route.isNotEmpty) _userStatus.visitRoute(route);
            },
          ),
        ),
      ).then(onComplete);

  /// Push to the [Helps] page.
  void toHelps() => pushTo(HelpsPage());

  /// Push to the [Help] page.
  void toHelp(AppHelpEntry helpEntry) => pushTo(HelpPage(helpEntry));

  /// Push to [Competitions] page.
  void toCompetitions({FutureOr<dynamic> Function(dynamic) onComplete}) =>
      pushTo(CompetitionsPage(), onComplete: onComplete);

  /// Push to the [Competition] page.
  void toCompetition(int id) => pushTo(
        CompetitionPage(
          id,
          ScrollController(),
        ),
      );

  /// A simple mapping of title to a page within the app for readablity.
  static Map<String, Widget Function(BuildContext)> get map => {
        home: (context) => homePage,
        home + Strings.competitionsText: (context) => competitionsPage,
        home + Strings.helpsText: (context) => helpsPage,
      };
}
