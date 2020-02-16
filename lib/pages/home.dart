import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class HomePage extends StatelessWidget {
  final Text _tapText = Text(
    'Tap anywhere to begin!',
    style: TextStyle(fontSize: 14, color: Palette.dark),
  );

  @override
  Widget build(BuildContext context) {
    /// REMOVE ME
    /// Privileges.clearPreferences();

    return GestureDetector(
        onTap: () => Toolkit.navigateTo(context, Strings.competitionsText),
        child: Scaffold(
          body: Center(
              child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsetsDirectional.only(top: 90)),
              Image.asset(Strings.iconPath),
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
