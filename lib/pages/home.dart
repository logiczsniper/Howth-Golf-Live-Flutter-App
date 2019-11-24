import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/opacity_change.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  /// TEMPORARY TO CLEAR PREFERENCES EACH BOOT
  void _clearPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  static Text _getTapText() {
    return Text(
      'Tap anywhere to begin!',
      style: TextStyle(fontSize: 14, color: Toolkit.primaryAppColorDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// REMOVE ME
    /// _clearPreferences();

    return GestureDetector(
        onTap: () => Toolkit.navigateTo(context, Toolkit.competitionsText),
        child: Scaffold(
          body: Center(
              child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsetsDirectional.only(top: 90)),
              new Image.asset('lib/static/newIcon.png'),
              Padding(padding: EdgeInsetsDirectional.only(top: 200)),
              OpacityChangeWidget(
                target: _getTapText(),
                flashing: true,
              ),
            ],
          )),
          backgroundColor: Toolkit.primaryAppColor,
        ));
  }
}
