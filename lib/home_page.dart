import 'package:flutter/material.dart';
import 'package:howth_golf_live/flashing_element.dart';

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              print("Tapped mE");
            },
            child: Center(
                child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsetsDirectional.only(top: 90)),
                new Image.asset('images/icon.png'),
                Padding(padding: EdgeInsetsDirectional.only(top: 550)),
                FlashingElement(Text(
                  'Tap anywhere to begin!',
                  style: Theme.of(context).textTheme.body1,
                ))
              ],
            ))));
  }
}
