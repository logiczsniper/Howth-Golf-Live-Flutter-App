import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class AppBarBase {
  String inputText = "";
  String title;
  Widget appBarTitle;
  Widget primaryTitle;
  Widget secondaryTitle;

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

  Center buildPrimaryBar(String title) {
    return Center(
        child: Text(title,
            style: TextStyle(
              color: Constants.primaryAppColorDark,
            )));
  }

  TextField buildSecondaryBar(TextInputType textType, bool obscureText,
      String hintText, TextEditingController _filter) {
    return TextField(
      keyboardType: textType,
      obscureText: obscureText,
      cursorColor: Constants.accentAppColor,
      textCapitalization: TextCapitalization.sentences,
      autocorrect: false,
      controller: _filter,
      style: TextStyle(color: Constants.primaryAppColorDark),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(1.5),
          enabledBorder: Constants.outlineInputBorder,
          focusedBorder: Constants.outlineInputBorder,
          prefixIcon: Icon(Icons.keyboard_arrow_right,
              color: Constants.primaryAppColorDark),
          hintText: hintText,
          hintStyle: Constants.appTheme.textTheme.subhead),
    );
  }
}
