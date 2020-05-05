import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/input_fields/decorated.dart';

/// A [DateTimeField] with decorations.
///
/// This includes [Padding], [cursorColor], [style], [decoration] values set.
/// Uses the same methods from parent [DecoratedField] to have consistent
/// styling across the app.
///
/// [withPadding] determines whether or not to add padding to the bottom
/// of the field or not. This makes the forms look better in cases where
/// one of them has underline text. Without additional padding below the
/// form, that field will look a bit smushed and too close to the field
/// below it.
class DecoratedDateTimeField extends StatelessWidget with DecoratedField {
  final TextEditingController controller = TextEditingController();
  final String hintText;
  final String initialValue;
  final bool withPadding;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedDateTimeField(
    this.hintText, {
    this.withPadding = true,
    this.initialValue = Strings.empty,
  });

  @override
  Widget build(BuildContext context) {
    controller.text = initialValue;
    return Padding(
      padding: getPadding(withPadding, false),
      child: DateTimeField(
        initialValue: DateTime.tryParse(initialValue),
        resetIcon: null,
        cursorColor: Palette.maroon,
        controller: controller,
        style: TextStyles.form,
        decoration: getDecoration(context, hintText),
        format: format,
        validator: (input) {
          return validator(
            input ?? initialValue,
            true,
          );
        },
        onShowPicker: (context, currentValue) async {
          final date = await showRoundedDatePicker(
              context: context,
              borderRadius: 13.0,
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
