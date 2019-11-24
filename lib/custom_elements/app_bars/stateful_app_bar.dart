import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class StatefulAppBar {
  String inputText = "";
  String title;
  Widget appBarTitle;
  Widget titleBar;
  Widget inputBar;

  Widget actionPressed(
      Widget appBarTitle,
      Widget primaryTitle,
      Widget secondaryTitle,
      BuildContext context,
      TextEditingController _filter) {
    if (appBarTitle == secondaryTitle) {
      _filter.clear();
      FocusScope.of(context).requestFocus(new FocusNode());
    }
    return appBarTitle == primaryTitle ? secondaryTitle : primaryTitle;
  }

  static InputDecoration _getInputDecoration(String hintText) {
    return InputDecoration(
        contentPadding: EdgeInsets.all(1.5),
        enabledBorder: Toolkit.outlineInputBorder,
        focusedBorder: Toolkit.outlineInputBorder,
        prefixIcon: Icon(Icons.keyboard_arrow_right),
        hintText: hintText,
        hintStyle: Toolkit.hintTextStyle);
  }

  AnimatedSwitcher getTitle(Widget appBarTitle) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 500), child: appBarTitle);
  }

  Center buildTitleBar(String title) {
    return Center(
        child: Text(title,
            style: TextStyle(
              color: Toolkit.primaryAppColorDark,
            )));
  }

  TextField buildInputBar(TextInputType textType, bool obscureText,
      String hintText, TextEditingController _filter) {
    return TextField(
        keyboardType: textType,
        obscureText: obscureText,
        cursorColor: Toolkit.accentAppColor,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        controller: _filter,
        style: TextStyle(color: Toolkit.primaryAppColorDark),
        decoration: _getInputDecoration(hintText));
  }
}
