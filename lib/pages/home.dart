import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class HomePage extends StatelessWidget {
  Text get _tapText => Text(
        Strings.tapMe,
        style: TextStyle(fontSize: 14, color: Palette.dark),
      );

  Padding get _howthLogo => Padding(
      child: Image.asset(Strings.iconPath),
      padding: EdgeInsets.symmetric(vertical: 100));

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
              _howthLogo,
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
