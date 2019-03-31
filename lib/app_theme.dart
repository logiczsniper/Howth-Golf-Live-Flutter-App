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
        body1: TextStyle(
            fontSize: 21, color: Colors.black, fontWeight: FontWeight.w300),
        body2: TextStyle(
            fontSize: 21,
            color: Color.fromARGB(255, 187, 187, 187),
            fontWeight: FontWeight.w300),
        caption: TextStyle(
            fontSize: 26, color: Colors.black, fontWeight: FontWeight.w500),
      ));
}
