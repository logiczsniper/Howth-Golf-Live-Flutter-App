import 'package:flutter/material.dart';

/// Simply removed overscroll effects.
/// Did not look good with the effects.
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;
}
