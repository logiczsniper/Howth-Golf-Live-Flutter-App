import 'package:flutter/material.dart';

class AppThemeData {
  ThemeData build() => ThemeData(
      primaryColor: Colors.white,
      primaryColorDark: Color.fromARGB(255, 187, 187, 187),
      accentColor: Color.fromARGB(255, 153, 0, 0),
      secondaryHeaderColor: Color.fromARGB(255, 57, 57, 57),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 187, 187, 187)),
      textTheme: TextTheme(
        headline: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        subhead:
            TextStyle(fontSize: 16, color: Color.fromARGB(255, 187, 187, 187)),
        body1: TextStyle(
            fontSize: 21, color: Colors.black, fontWeight: FontWeight.w300),
        body2: TextStyle(
            fontSize: 21,
            color: Color.fromARGB(255, 187, 187, 187),
            fontWeight: FontWeight.w300),
        caption: TextStyle(
            fontSize: 26,
            color: Color.fromARGB(255, 187, 187, 187),
            fontWeight: FontWeight.w500),
      ));
}
