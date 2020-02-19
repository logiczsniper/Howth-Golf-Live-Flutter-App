import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/pages/competitions.dart';
import 'package:howth_golf_live/pages/app_help.dart';
import 'package:howth_golf_live/pages/home.dart';
import 'package:howth_golf_live/services/privileges.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget get homePage => HomePage();
Widget get competitionsPage => CompetitionsPage();
Widget get helpPage => HelpPage();

class Routes {
  /// The initial route.
  static String get home => "/";

  /// Use [Navigator] to take the user to the main compeitions page.
  ///
  /// The [SharedPreferences] instance must be fetched and passed as
  /// an argument to [pushNamed] so the new page can determine whether or
  /// not the user is an admin and if so, adjust how it displays certain
  /// elements.
  static void navigateTo(BuildContext context, String destination) {
    final preferences = SharedPreferences.getInstance();
    preferences.then((SharedPreferences preferences) {
      Navigator.pushNamed(context, home + destination,
          arguments: Privileges.fromPreferences(preferences));
    });
  }

  /// Get the arguments passed through the route.
  static Privileges arguments(BuildContext context) =>
      ModalRoute.of(context).settings.arguments;

  /// A simple mapping of title to a page within the app for readablity.
  static Map<String, Widget Function(BuildContext)> get map => {
        home: (context) => homePage,
        home + Strings.competitionsText: (context) => competitionsPage,
        home + Strings.helpText: (context) => helpPage,
      };
}
