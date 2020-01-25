import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';

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

  static InputDecoration _getInputDecoration(String hintText) =>
      InputDecoration(
          contentPadding: EdgeInsets.all(1.5),
          enabledBorder: Toolkit.outlineInputBorder,
          focusedBorder: Toolkit.outlineInputBorder,
          prefixIcon: Icon(Icons.keyboard_arrow_right, color: Palette.dark),
          hintText: hintText,
          hintStyle: Toolkit.hintTextStyle);

  AnimatedSwitcher getTitle(Widget appBarTitle) => AnimatedSwitcher(
      duration: Duration(milliseconds: 500), child: appBarTitle);

  Center buildTitleBar(String title) => Center(
      child: Text(title,
          softWrap: true,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: Palette.dark,
          )));

  TextField buildInputBar(TextInputType textType, bool obscureText,
          String hintText, TextEditingController _filter) =>
      TextField(
          keyboardType: textType,
          obscureText: obscureText,
          cursorColor: Palette.maroon,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          controller: _filter,
          style: TextStyle(color: Palette.dark),
          decoration: _getInputDecoration(hintText));
}
