import 'package:flutter/material.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/themes.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class StatefulAppBar {
  String inputText = "";
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
              enabledBorder: UIToolkit.outlineInputBorder,
              focusedBorder: UIToolkit.outlineInputBorder,
              prefixIcon: Icon(
                Icons.keyboard_arrow_right,
                color: Palette.dark,
              ),
              hintText: hintText)
          .applyDefaults(Themes.inputDecorationTheme);

  /// The title must be an [AnimatedSwitcher].
  AnimatedSwitcher getTitle(Widget appBarTitle) => AnimatedSwitcher(
      duration: Duration(milliseconds: 500), child: appBarTitle);

  /// The simpler app bar that just displays text- the title.
  Widget buildTitleBar(String title) => Center(
      child: Text(title,
          softWrap: true,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: Themes.titleStyle));

  /// The search app bar which enables the user to type into a search box.
  /// Also the code field input bar.
  TextField buildInputBar(
          TextInputType textType,
          bool obscureText,
          String hintText,
          TextEditingController _filter,
          Function _codePressed) =>
      TextField(
        keyboardType: textType,
        obscureText: obscureText,
        cursorColor: Palette.maroon,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        controller: _filter,
        style: TextStyle(color: Palette.dark),
        decoration: _getInputDecoration(hintText),
        onSubmitted: (String _) => _codePressed(),
      );
}
