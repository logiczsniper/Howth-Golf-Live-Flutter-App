import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class HomePage extends StatelessWidget with AppResources {
  final String title;

  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navigate into app when tapped.
          Navigator.pushNamed(context, '/' + constants.competitionsText);
        },
        child: Scaffold(
            body: Center(
                child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsetsDirectional.only(top: 90)),
            new Image.asset('images/icon.png'),
            Padding(padding: EdgeInsetsDirectional.only(top: 400)),
            elementBuilder.buildFlashingElement(Text(
              'Tap anywhere to begin!',
              style: appTheme.textTheme.subhead,
            ))
          ],
        ))));
  }
}
