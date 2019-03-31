import 'package:flutter/material.dart';

class AppThemeData {
  ThemeData build() => ThemeData(
      primaryColor: Colors.white,
      accentColor: Color.fromARGB(1, 153, 0, 0),
      textTheme: TextTheme(
        headline: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        subhead: TextStyle(fontSize: 15, color: Colors.black),
        caption:
            TextStyle(fontSize: 15, color: Color.fromARGB(1, 187, 187, 187)),
      ));
}
