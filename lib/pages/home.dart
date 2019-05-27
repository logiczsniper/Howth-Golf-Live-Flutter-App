import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/fading_element.dart';
import 'package:howth_golf_live/static/constants.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navigate into app when tapped.
          Navigator.pushNamed(context, '/' + Constants.competitionsText);
        },
        child: Scaffold(
          body: Center(
              child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsetsDirectional.only(top: 90)),
              new Image.asset('lib/static/icon.png'),
              Padding(padding: EdgeInsetsDirectional.only(top: 400)),
              FadingElement(
                Text(
                  'Tap anywhere to begin!',
                  style: TextStyle(
                      fontSize: 14, color: Constants.primaryAppColorDark),
                ),
                true,
              )
            ],
          )),
          backgroundColor: Constants.primaryAppColor,
        ));
  }
}
