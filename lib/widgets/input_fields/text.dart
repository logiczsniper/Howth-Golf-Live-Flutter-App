import 'package:flutter/material.dart';

import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/input_fields/decorated.dart';

class DecoratedTextField extends StatelessWidget with DecoratedField {
  final TextEditingController controller = TextEditingController();
  final String hintText;
  final bool withPadding;
  final bool number;
  final bool isRequired;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedTextField(this.hintText,
      {this.withPadding = true, this.number = false, this.isRequired = true});

  @override
  Widget build(BuildContext context) => Padding(
      padding: getPadding(withPadding),
      child: TextFormField(
          cursorColor: Palette.maroon,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          controller: controller,
          style: TextStyles.formStyle,
          decoration: getDecoration(context, hintText),
          validator: (input) => validator(input, isRequired)));
}
