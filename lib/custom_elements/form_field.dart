import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class DecoratedFormField extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final String hintText;

  /// [hintText] is the text that will be displayed before the user types anything.
  DecoratedFormField(this.hintText);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Constants.accentAppColor,
      textCapitalization: TextCapitalization.sentences,
      autocorrect: false,
      controller: controller,
      style: TextStyle(color: Constants.primaryAppColorDark),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(1.5),
          enabledBorder: Constants.outlineInputBorder,
          focusedBorder: Constants.outlineInputBorder,
          prefixIcon: Icon(Icons.keyboard_arrow_right,
              color: Constants.primaryAppColorDark),
          hintText: hintText,
          hintStyle: Constants.hintTextStyle),
      validator: (String input) {
        if (input.isEmpty) {
          return 'This field is required.';
        }
      },
    );
  }
}
