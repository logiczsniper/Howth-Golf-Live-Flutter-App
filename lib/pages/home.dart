import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  /// TEMPORARY TO CLEAR PREFERENCES (privileges) EACH BOOT
  void _clearPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  final Text _tapText = Text(
    'Tap anywhere to begin!',
    style: TextStyle(fontSize: 14, color: Palette.dark),
  );

  @override
  Widget build(BuildContext context) {
    /// REMOVE ME
    _clearPreferences();

    return GestureDetector(
        onTap: () => Toolkit.navigateTo(context, Toolkit.competitionsText),
        child: Scaffold(
          body: Center(
              child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsetsDirectional.only(top: 90)),
              Image.asset(Toolkit.iconPath),
              Padding(padding: EdgeInsetsDirectional.only(top: 200)),
              OpacityChangeWidget(
                target: _tapText,
                flashing: true,
              ),
            ],
          )),
          backgroundColor: Palette.light,
        ));
  }
}
