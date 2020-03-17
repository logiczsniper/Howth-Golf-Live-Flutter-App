import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/home/authentication_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';

class HomePage extends StatelessWidget {
  Widget _tapText(String text) => Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: OpacityChangeWidget(
          flashing: true,
          target: Text(
            text,
            style: TextStyles.formStyle,
          )));

  Widget get _howthText => Text(Strings.appTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Palette.maroon,
          height: 1.0,
          fontSize: 40.0,
          fontFamily: Strings.cormorantGaramond));

  Widget get _howthLogo => Center(
      child: SvgPicture.asset(Strings.iconPath,
          color: Palette.inMaroon.withAlpha(40), width: 200.0, height: 380.0));

  Widget _page(
          BuildContext context, AuthenticationViewModel authenticationModel) =>
      GestureDetector(
          onTap: () {
            authenticationModel.anonymousSignIn(context);
          },
          child: Scaffold(
              body: Stack(alignment: Alignment.topCenter, children: <Widget>[
            OpacityChangeWidget(target: _howthLogo),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _howthText,
                  _tapText(authenticationModel.status)
                ])
          ])));

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationViewModel>(
        builder: (context, authenticationViewModel, _) {
      if (authenticationViewModel.status == Strings.connected) {
        authenticationViewModel.status = Strings.entering;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Routes.of(context).toCompetitions();
        });
      }
      return _page(context, authenticationViewModel);
    });
  }
}
