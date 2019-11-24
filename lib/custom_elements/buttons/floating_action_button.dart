import 'package:flutter/material.dart';

import 'package:howth_golf_live/static/toolkit.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  MyFloatingActionButton({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(
        Icons.add,
        color: Toolkit.primaryAppColorDark,
      ),
      backgroundColor: Toolkit.accentAppColor,
      label: Text(
        text,
        style: TextStyle(fontSize: 14, color: Toolkit.primaryAppColorDark),
      ),
      onPressed: onPressed,
    );
  }
}
