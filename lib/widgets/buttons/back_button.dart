import 'package:flutter/material.dart';
import 'package:howth_golf_live/routing/routes.dart';

class ParameterBackButton extends StatelessWidget {
  /// Custom back button which allows the passage of arguemnts.
  ///
  /// When navigating to Competitions, any Competition, and App Help,
  /// [_preferences] must be passed. This button mimics the provided
  /// [BackButtonIcon] in Flutter, except passes [_preferences] to the
  /// [destination] page.
  final String destination;
  ParameterBackButton(this.destination);

  Widget build(BuildContext context) => IconButton(
      icon: const BackButtonIcon(),
      onPressed: () {
        Routes.navigateTo(context, destination);
      });
}
