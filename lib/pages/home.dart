import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';

class HomePage extends StatelessWidget {
  Text get _tapText => Text(
        Strings.tapMe,
        style: TextStyle(fontSize: 14, color: Palette.dark),
      );

  Padding get _howthLogo => Padding(
      child: Image.asset(Strings.iconPath),
      padding: EdgeInsets.symmetric(vertical: 100));

  SnackBar get _snackBar => SnackBar(
        content: Text(
          "Failed to connect to Firebase!",
          textAlign: TextAlign.center,
        ),
      );

  Future<AuthResult> anonymousSignIn() async =>
      await FirebaseAuth.instance.signInAnonymously();

  @override
  Widget build(BuildContext context) {
    /// REMOVE ME
    /// Privileges.clearPreferences();

    /// Sign the user out when building!
    FirebaseAuth.instance.signOut();

    return GestureDetector(
        onTap: () {
          anonymousSignIn().then((AuthResult result) {
            if (result.user == null)
              Scaffold.of(context).showSnackBar(_snackBar);
            else
              Routes.navigateTo(context, Strings.competitionsText);
          });
        },
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
        ));
  }
}
