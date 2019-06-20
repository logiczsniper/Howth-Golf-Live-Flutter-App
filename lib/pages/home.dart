import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/fading_element.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  /// TEMPORARY TO CLEAR PREFERENCES EACH BOOT
  void _clearPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    /// REMOVE ME
    _clearPreferences();

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
              new Image.asset('lib/static/newIcon.png'),
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
