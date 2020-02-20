import 'package:flutter/material.dart';
import 'package:howth_golf_live/style/palette.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  /// Custom [FloatingActionButton] which is used for creating
  /// holes and competitions.
  MyFloatingActionButton({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        icon: Icon(
          Icons.add,
          color: Palette.inMaroon,
        ),
        label: Text(
          text,
          style: TextStyle(fontSize: 14, color: Palette.inMaroon),
        ),
        onPressed: onPressed,
      );
}
