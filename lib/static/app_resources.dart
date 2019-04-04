import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_theme.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/element_builder.dart';

abstract class AppResources {
  final Constants constants = Constants();
  final ElementBuilder elementBuilder = ElementBuilder();
  final ThemeData appTheme = AppThemeData().build();
}
