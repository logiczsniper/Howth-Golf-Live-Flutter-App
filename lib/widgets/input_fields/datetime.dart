import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/input_fields/decorated.dart';

class DecoratedDateTimeField extends StatelessWidget with DecoratedField {
  final TextEditingController controller = TextEditingController();
  final String hintText;
  final bool withPadding;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedDateTimeField(this.hintText, {this.withPadding = true});

  String _validator(DateTime input) {
    if (input == null)
      return 'This field is required.';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: getPadding(withPadding),
        child: DateTimeField(
          resetIcon: null,
          cursorColor: Palette.maroon,
          controller: controller,
          style: TextStyle(color: Palette.dark),
          decoration: getDecoration(hintText),
          format: format,
          validator: _validator,
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
