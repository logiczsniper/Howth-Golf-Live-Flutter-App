import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:intl/intl.dart';

class DecoratedField {
  final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

  /// Modifies the field to a nicer looking string.
  ///
  /// Does this by capitalising each term and replaces "_" with " ".
  String _format(String input) {
    input = input.replaceAll("_", " ");

    String caps = "";

    for (String word in input.split(" ")) {
      caps += word[0].toUpperCase() + word.substring(1) + " ";
    }

    return caps.trim();
  }

  InputDecoration getDecoration(String hintText) => InputDecoration(
      contentPadding: EdgeInsets.all(16.0),
      prefixIcon: Icon(Icons.keyboard_arrow_right, color: Palette.dark),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Palette.maroon)),
      disabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Palette.maroon)),
      hintText: _format(hintText),
      hintStyle: Toolkit.hintTextStyle);

  EdgeInsets getPadding(bool withPadding) =>
      EdgeInsets.only(bottom: withPadding ? 25 : 0);
}
