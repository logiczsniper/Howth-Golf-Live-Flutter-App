import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/themes.dart';
import 'package:howth_golf_live/app/connectivity_view_model.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class StatefulAppBar {
  String inputText = Strings.empty;
  String title;
  Widget appBarTitle;
  Widget titleBar;
  Widget inputBar;

  /// Returns the next [appBarTitle].
  Widget actionPressed(
      Widget appBarTitle, BuildContext context, TextEditingController _filter) {
    if (appBarTitle == inputBar) {
      _filter.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }
    return appBarTitle == titleBar ? inputBar : titleBar;
  }

  /// Get a custom instantiated [InputDecoration].
  static InputDecoration _getInputDecoration(String hintText) =>
      InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hintText)
          .applyDefaults(Themes.inputDecorationTheme);

  /// The title must be an [AnimatedSwitcher].
  AnimatedSwitcher getTitle(Widget appBarTitle) => AnimatedSwitcher(
      duration: Duration(milliseconds: 350), child: appBarTitle);

  void checkConnectivity(BuildContext context) {
    var _connectivityStatus = Provider.of<ConnectivityViewModel>(context);

    if (_connectivityStatus.isNotConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scaffold.of(context).showSnackBar(UIToolkit.snackbar(
            Strings.noConnection,
            duration: Duration(seconds: 8)));
      });
    }
  }

  /// The simpler app bar that just displays text- the title.
  Widget buildTitleBar(String title) => Center(
          child: Text(
        title == Strings.competitionsText ? Strings.empty : title,
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
      ));

  /// The search app bar which enables the user to type into a search box.
  /// Also the code field input bar.
  Widget buildInputBar(
          TextInputType textType,
          bool obscureText,
          String hintText,
          TextEditingController _filter,
          Function _codePressed) =>
      Container(
          height: 45,
          decoration: BoxDecoration(
              color: Palette.light,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Palette.dark,
                  spreadRadius: 0.3,
                  blurRadius: 1.5,
                  offset: Offset(0, 0.75),
                )
              ],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0)),
          child: TextField(
            keyboardType: textType,
            obscureText: obscureText,
            cursorColor: Palette.maroon,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            controller: _filter,
            style: TextStyle(color: Palette.dark),
            decoration: _getInputDecoration(hintText),
            onSubmitted: (_) => _codePressed(),
          ));
}
