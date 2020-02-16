import 'package:flutter/material.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/themes.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

import 'constants/strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  /// The root of the app.
  @override
  Widget build(BuildContext context) => MaterialApp(
      builder: Toolkit.appBuilder,
      title: Strings.appName,
      initialRoute: Routes.home,
      routes: Routes.map,
      theme: Themes.appTheme);
}
