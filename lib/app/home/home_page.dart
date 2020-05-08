import 'package:flutter/material.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/home/authentication_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';

class HomePage extends StatelessWidget {
  /// Prompts the user to tap the screen, signing them in.
  Widget _tapText(String text) => OpacityChangeWidget(
        flashing: true,
        target: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyles.form.copyWith(color: Palette.dark, fontSize: 14),
        ),
      );

  /// The title of the app.
  Widget get _howthText => Padding(
        padding: EdgeInsets.only(bottom: 10.0, top: 0.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 8.0),
              child: Text(
                Strings.homeAddress,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.darker,
                  height: 1.0,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w800,
                  fontFamily: Strings.cormorantGaramond,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
                  decoration: UIToolkit.roundedRectBoxDecoration.copyWith(
                    color: Palette.maroon,
                  ),
                  child: Text(
                    "live",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Palette.inMaroon,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                Text(
                  " competition scoring",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Palette.dark,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w200,
                  ),
                )
              ],
            )
          ],
        ),
      );

  /// The logo on the front.
  Widget get _howthLogo => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15.0),
        child: UIToolkit.svgHowthLogo(
          width: 60.0,
        ),
      );

  /// The entire page.
  Widget _page(
    BuildContext context,
    AuthenticationViewModel authenticationModel,
  ) =>
      GestureDetector(
        onTap: () {
          /// On tap, sign the user in via the [AuthenticationViewModel].
          authenticationModel.anonymousSignIn(context);
        },
        child: Scaffold(
          backgroundColor: Palette.light,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12.0),
            child: _tapText(authenticationModel.status),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OpacityChangeWidget(target: _howthLogo),
                _howthText,
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationViewModel>(
        builder: (context, authenticationViewModel, _) {
      if (authenticationViewModel.status == Strings.connected) {
        /// We cant navigate while this page is building, so we add
        /// a [PostFrameCallback] instead.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Routes.of(context)
              .toCompetitions(onComplete: authenticationViewModel.resetText);
        });
      }
      return _page(context, authenticationViewModel);
    });
  }
}
