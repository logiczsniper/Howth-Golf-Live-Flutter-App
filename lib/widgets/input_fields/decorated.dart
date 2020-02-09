import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:intl/intl.dart';

class DecoratedField {
  final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

  UnderlineInputBorder get _border => UnderlineInputBorder(
      borderSide: BorderSide(color: Palette.maroon, width: 1.5));

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

  /// [InputDecoration] with a red underline in every state and custom
  /// [hintText].
  InputDecoration getDecoration(String hintText) => InputDecoration(
      contentPadding: EdgeInsets.all(16.0),
      prefixIcon: Icon(Icons.keyboard_arrow_right, color: Palette.dark),
      focusedBorder: _border,
      errorBorder: _border,
      enabledBorder: _border,
      disabledBorder: _border,
      hintText: _format(hintText),
      hintStyle: Toolkit.hintTextStyle);

  EdgeInsets getPadding(bool withPadding) =>
      EdgeInsets.only(bottom: withPadding ? 25 : 0);
}
