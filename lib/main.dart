import 'package:flutter/material.dart';
import 'package:howth_golf_live/home_page.dart';
import 'package:howth_golf_live/app_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Howth Golf Live',
        theme: AppThemeData().build(),
        home: HomePage(title: 'Howth Golf Live'));
  }
}
