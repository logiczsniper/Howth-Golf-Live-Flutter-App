import 'package:flutter/material.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/input_fields/decorated.dart';

/// [TextFormField] which utilizes the [DecoratedField] class to
/// maintain its style.
///
/// @see [DecoratedDateTimeField.withPadding]
/// @see [DecoratedDateTimeField.hintText]
///
/// [number] specifies whether or not the text input will only be
/// integers. If this is true, a number keypad is used instead of the
/// standard QWERTY keyboard.
///
/// [noteText] is the (optional) text which is put below the input
/// field.
class DecoratedTextField extends StatelessWidget with DecoratedField {
  final TextEditingController controller = TextEditingController();
  final String hintText;
  final String initialValue;
  final bool withPadding;
  final bool number;
  final bool isRequired;
  final String noteText;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedTextField(
    this.hintText, {
    this.withPadding = false,
    this.number = false,
    this.isRequired = true,
    this.initialValue = Strings.empty,
    this.noteText = Strings.empty,
  });

  @override
  Widget build(BuildContext context) {
    controller.text = initialValue;
    return Padding(
        padding: getPadding(withPadding, noteText != Strings.empty),
        child: TextFormField(
            cursorColor: Palette.maroon,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            keyboardType: number ? TextInputType.number : TextInputType.text,
            maxLength: number ? 2 : 80,
            controller: controller,
            style: TextStyles.form,
            decoration: getDecoration(context, hintText, noteText),
            validator: (input) => validator(input, isRequired)));
  }
}
