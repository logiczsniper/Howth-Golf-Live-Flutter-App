import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/input_fields/decorated.dart';

class DecoratedDateTimeField extends StatelessWidget with DecoratedField {
  final TextEditingController controller = TextEditingController();
  final String hintText;
  final String initialValue;
  final bool withPadding;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedDateTimeField(this.hintText,
      {this.withPadding = true, this.initialValue = Strings.empty});

  @override
  Widget build(BuildContext context) {
    controller.text = initialValue;
    return Padding(
      padding: getPadding(withPadding),
      child: DateTimeField(
        initialValue: DateTime.tryParse(initialValue),
        resetIcon: null,
        cursorColor: Palette.maroon,
        controller: controller,
        style: TextStyles.formStyle,
        decoration: getDecoration(context, hintText),
        format: format,
        validator: (input) => validator(input, true),
        onShowPicker: (context, currentValue) async {
          final date = await showRoundedDatePicker(
              context: context,
              borderRadius: 10.0,
              theme: Theme.of(context),
              initialDate: DateTime.now(),
              initialDatePickerMode: DatePickerMode.day);
          if (date != null) {
            final time = await showRoundedTimePicker(
              context: context,
              theme: Theme.of(context),
              initialTime: TimeOfDay.now(),
            );
            return DateTimeField.combine(date, time);
          }
          return currentValue;
        },
      ),
    );
  }
}
