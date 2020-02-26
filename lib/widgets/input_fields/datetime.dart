import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:howth_golf_live/presentation/utils.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/input_fields/decorated.dart';

class DecoratedDateTimeField extends StatelessWidget with DecoratedField {
  final TextEditingController controller = TextEditingController();
  final String hintText;
  final bool withPadding;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedDateTimeField(this.hintText, {this.withPadding = true});

  @override
  Widget build(BuildContext context) => Padding(
        padding: getPadding(withPadding),
        child: DateTimeField(
          resetIcon: null,
          cursorColor: Palette.maroon,
          controller: controller,
          style: TextStyle(color: Palette.dark),
          decoration: getDecoration(context, hintText),
          format: format,
          validator: (DateTime input) => Utils.validator(input, true),
          onShowPicker: (BuildContext context, DateTime currentValue) async {
            final date = await showRoundedDatePicker(
                context: context,
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
