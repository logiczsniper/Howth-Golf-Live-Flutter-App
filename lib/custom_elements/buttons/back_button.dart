import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class ParameterBackButton extends StatelessWidget {
  /// Custom back button which allows the passage of arguemnts.
  ///
  /// When navigating to Competitions, any Competition, and App Help,
  /// [preferences] must be passed. This button mimics the provided
  /// [BackButtonIcon] in Flutter, except passes [preferences] to the
  /// [destination] page.
  final String destination;
  ParameterBackButton(this.destination);

  Widget build(BuildContext context) {
    return IconButton(
        icon: const BackButtonIcon(),
        onPressed: () {
          Toolkit.navigateTo(context, destination);
        });
  }
}
