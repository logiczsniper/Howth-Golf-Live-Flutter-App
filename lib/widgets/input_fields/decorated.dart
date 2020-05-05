import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';

/// The underlying class to all input fields.
///
/// Supplies methods and variables for consistent styling
/// across the fields.
///
/// [format] is the Irish standard date format.
class DecoratedField {
  final DateFormat format = DateFormat("dd-MM-yyyy HH:mm");

  /// Modifies the field to a nicer looking string.
  ///
  /// Does this by capitalising each term and replaces "_" with " ".
  String _formatHintText(String input) {
    if (input.isEmpty) return input;

    input = input.replaceAll("_", " ");

    String caps = Strings.empty;

    for (String word in input.split(" ")) {
      caps += word[0].toUpperCase() + word.substring(1) + " ";
    }

    return caps.trim();
  }

  /// Require some form of input.
  ///
  /// If null is returned, the validation counts
  /// as passing.
  ///
  /// If a non-null is returned, the validations counts
  /// as failed.
  ///
  /// If it [isRequired], and there is no [input], then
  /// return a String.
  ///
  /// [input] is kept dynamic as this is the validator for both [DateTimeField] and
  /// [TextInputField]. It must accept both a [String] and [DateTime] as [input].
  String validator(dynamic input, bool isRequired) =>
      input == null || input == Strings.empty && isRequired
          ? Strings.requiredField
          : null;

  /// [InputDecoration] with a red underline in every state and custom
  /// [hintText].
  InputDecoration getDecoration(
    BuildContext context,
    String hintText, [
    String noteText = "",
  ]) =>
      InputDecoration(
        helperText: noteText,
        helperMaxLines: 2,
        hintText: _formatHintText(hintText),
        prefixIcon: Icon(
          Icons.keyboard_arrow_right,
          color: Palette.dark,
        ),
      ).applyDefaults(Theme.of(context).inputDecorationTheme);

  EdgeInsets getPadding(bool withPadding, bool hasNote) => EdgeInsets.only(
        bottom:
            hasNote ? (withPadding ? 25 : 0) + 8.0 : (withPadding ? 25 : 0.0),
      );
}
