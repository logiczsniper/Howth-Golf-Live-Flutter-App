import 'package:flutter/material.dart';
import 'package:howth_golf_live/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Howth Golf Live',
        theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Color.fromARGB(1, 153, 0, 0),
            textTheme: TextTheme(
                headline: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
                body1: TextStyle(fontSize: 15, color: Colors.black),
                body2: TextStyle(
                    fontSize: 15, color: Color.fromARGB(1, 187, 187, 187)))),
        home: HomePage(title: 'Howth Golf Live'));
  }
}
