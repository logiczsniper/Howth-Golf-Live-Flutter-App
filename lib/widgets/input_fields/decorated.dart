import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:intl/intl.dart';

class DecoratedField {
  final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

  /// [InputDecoration] with a red underline in every state and custom
  /// [hintText].
  InputDecoration getDecoration(BuildContext context, String hintText) =>
      InputDecoration(
              prefixIcon: Icon(
                Icons.keyboard_arrow_right,
                color: Palette.dark,
              ),
              hintText: Strings.formatHintText(hintText))
          .applyDefaults(Theme.of(context).inputDecorationTheme);

  EdgeInsets getPadding(bool withPadding) =>
      EdgeInsets.only(bottom: withPadding ? 25 : 0);
}
