import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_theme.dart';
import 'package:howth_golf_live/static/app_constants.dart';

abstract class AppResources {
  final Constants constants = Constants();
  final ThemeData appTheme = AppThemeData().build();
}
