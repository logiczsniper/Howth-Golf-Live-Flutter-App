import 'package:flutter/material.dart';
import 'package:howth_golf_live/flashing_element.dart';
import 'package:howth_golf_live/primary_app.dart';

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navigate into app when tapped.
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PrimaryApp()));
        },
        child: Scaffold(
            body: Center(
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
