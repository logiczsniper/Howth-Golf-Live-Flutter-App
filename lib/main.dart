import 'package:flutter/material.dart';

import 'package:howth_golf_live/custom_elements/scroll_behavior.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/pages/apphelp.dart';
import 'package:howth_golf_live/pages/home.dart';
import 'package:howth_golf_live/pages/competitions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  /// Serves as the builder method for the [MaterialApp].
  ///
  /// Uses [CustomScrollBehavior] to improve app aesthetic.
  ScrollConfiguration appBuilder(BuildContext context, Widget child) {
    return ScrollConfiguration(behavior: CustomScrollBehavior(), child: child);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: appBuilder,
        title: Constants.appName,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => HomePage(),
          '/' + Constants.competitionsText: (context) => CompetitionsPage(),
          '/' + Constants.appHelpText: (context) => AppHelpPage()
        });
  }
}
