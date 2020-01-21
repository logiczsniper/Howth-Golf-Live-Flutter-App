import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:intl/intl.dart';

class DecoratedField {
  final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

  String _capitalize(String input) {
    String caps = "";

    for (String word in input.split(" ")) {
      caps += word[0].toUpperCase() + word.substring(1) + " ";
    }

    return caps.trim();
  }

  InputDecoration getDecoration(String hintText) => InputDecoration(
      contentPadding: EdgeInsets.all(16.0),
      enabledBorder: Toolkit.outlineInputBorder,
      focusedBorder: Toolkit.outlineInputBorder,
      prefixIcon: Icon(Icons.keyboard_arrow_right, color: Palette.dark),
      hintText: _capitalize(hintText),
      hintStyle: Toolkit.hintTextStyle);

  EdgeInsets getPadding(bool withPadding) =>
      EdgeInsets.only(bottom: withPadding ? 25 : 0);
}
