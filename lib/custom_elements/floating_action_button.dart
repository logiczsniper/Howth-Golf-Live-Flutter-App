import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function onPressed;
  MyFloatingActionButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(
        Icons.add,
        color: Constants.primaryAppColorDark,
      ),
      label: const Text(
        'Add a Competition',
        style: TextStyle(fontSize: 14, color: Constants.primaryAppColorDark),
      ),
      onPressed: onPressed,
    );
  }
}
