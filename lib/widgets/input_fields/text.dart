import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/input_fields/decorated.dart';

class DecoratedTextField extends StatelessWidget with DecoratedField {
  final TextEditingController controller = TextEditingController();
  final String hintText;
  final bool withPadding;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedTextField(this.hintText, {this.withPadding = true});

  /// A basic test to see if the user has inserted text.
  String _validator(String input) {
    if (input.isEmpty)
      return 'This field is required.';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: getPadding(withPadding),
      child: TextFormField(
          cursorColor: Palette.maroon,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          controller: controller,
          style: TextStyle(color: Palette.dark),
          decoration: getDecoration(hintText),
          validator: _validator));
}
