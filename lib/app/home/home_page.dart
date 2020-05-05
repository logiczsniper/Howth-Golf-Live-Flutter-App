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
  Widget _tapText(String text) => Padding(
      padding: EdgeInsets.all(8.0),
      child: OpacityChangeWidget(
          flashing: true,
          target: Text(
            text,
            style: TextStyles.form,
          )));

  /// The title of the app.
  Widget get _howthText => Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(Strings.appTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Palette.maroon,
                height: 1.0,
                fontSize: 40.0,
                fontFamily: Strings.cormorantGaramond)),
      );

  /// The logo on the front.
  Widget get _howthLogo => Center(
        child: UIToolkit.svgHowthLogo(width: 100.0, height: 190.0),
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OpacityChangeWidget(target: _howthLogo),
                _howthText,
                UIToolkit.getCard(_tapText(authenticationModel.status)),
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
        authenticationViewModel.status = Strings.entering;

        /// We cant navigate while this page is building, so we add
        /// a [PostFrameCallback] instead.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Routes.of(context).toCompetitions(onComplete: (_) {
            authenticationViewModel.status = Strings.tapMe;
          });
        });
      }
      return _page(context, authenticationViewModel);
    });
  }
}
