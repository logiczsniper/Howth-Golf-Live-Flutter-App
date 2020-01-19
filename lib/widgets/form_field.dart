import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:intl/intl.dart';

class DecoratedField {
  final TextEditingController controller = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");

  static InputDecoration _getDecoration(String hintText) => InputDecoration(
      contentPadding: EdgeInsets.all(1.5),
      enabledBorder: Toolkit.outlineInputBorder,
      focusedBorder: Toolkit.outlineInputBorder,
      prefixIcon: Icon(Icons.keyboard_arrow_right, color: Palette.dark),
      hintText: hintText,
      hintStyle: Toolkit.hintTextStyle);

  static EdgeInsets _getPadding(bool withPadding) =>
      EdgeInsets.only(bottom: withPadding ? 10 : 0);
}

class DecoratedDateTimeField extends StatelessWidget with DecoratedField {
  final String hintText;
  final bool withPadding;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedDateTimeField(this.hintText, {this.withPadding = true});

  @override
  Widget build(BuildContext context) => Padding(
        padding: DecoratedField._getPadding(withPadding),
        child: DateTimeField(
          cursorColor: Palette.maroon,
          controller: controller,
          style: TextStyle(color: Palette.dark),
          decoration: DecoratedField._getDecoration(hintText),
          format: format,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            }
            return currentValue;
          },
        ),
      );
}

class DecoratedTextField extends StatelessWidget with DecoratedField {
  final String hintText;
  final bool withPadding;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedTextField(this.hintText, {this.withPadding = true});

  @override
  Widget build(BuildContext context) => Padding(
      padding: DecoratedField._getPadding(withPadding),
      child: TextFormField(
        cursorColor: Palette.maroon,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        controller: controller,
        style: TextStyle(color: Palette.dark),
        decoration: DecoratedField._getDecoration(hintText),
        validator: (String input) {
          if (input.isEmpty) {
            return 'This field is required.';
          }
        },
      ));
}
