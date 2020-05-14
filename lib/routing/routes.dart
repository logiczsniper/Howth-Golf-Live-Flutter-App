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

typedef OnCompleteCallback = FutureOr<dynamic> Function(dynamic);

class Routes {
  /// The initial route.
  static String get home => "/";

  BuildContext context;
  Routes(this.context);
  Routes.of(BuildContext context) : context = context;

  /// Push to [destination].
  void pushTo(Widget destination, {OnCompleteCallback onComplete, String name}) => Navigator.push(
        context,
        LongMaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: (context) => ShowCaseWidget(
            builder: Builder(builder: (_) => destination),
            onFinish: () {
              var _userStatus = Provider.of<UserStatusViewModel>(context, listen: false);

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
  void toHelps() => pushTo(helpsPage);

  /// Push to the [Help] page.
  void toHelp(AppHelpEntry helpEntry) => pushTo(HelpPage(helpEntry));

  /// Push to [Competitions] page.
  void toCompetitions({OnCompleteCallback onComplete}) =>
      pushTo(competitionsPage, onComplete: onComplete, name: home + Strings.competitionsText);

  /// Push to the [Competition] page.
  void toCompetition(int id) => pushTo(CompetitionPage(id));

  /// Uses [popUntil] to repeatedly pop until the [CompetitionsPage] is reached.
  void popToCompetitions() => Navigator.of(context).popUntil((Route route) {
        return route.settings.name == (home + Strings.competitionsText);
      });

  /// A simple mapping of title to a page within the app for readablity.
  static Map<String, Widget Function(BuildContext)> get map => {
        home: (context) => homePage,
      };
}
