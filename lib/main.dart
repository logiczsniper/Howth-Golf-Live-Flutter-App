import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/home_page.dart';
import 'package:howth_golf_live/app_theme.dart';
import 'package:howth_golf_live/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Constants().appName,
        theme: AppThemeData().build(),
        home: HomePage(title: Constants().appName));
  }
}
