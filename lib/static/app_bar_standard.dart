import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class StandardAppBar extends StatelessWidget with AppResources {
  final String title;

  StandardAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: TextStyle(color: appTheme.primaryColorDark)),
      backgroundColor: appTheme.primaryColor,
      iconTheme: IconThemeData(color: appTheme.primaryColorDark),
    );
  }
}
