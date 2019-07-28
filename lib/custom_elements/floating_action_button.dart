import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  MyFloatingActionButton({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(
        Icons.add,
        color: Constants.primaryAppColorDark,
      ),
      label: Text(
        text,
        style: TextStyle(fontSize: 14, color: Constants.primaryAppColorDark),
      ),
      onPressed: onPressed,
    );
  }
}
