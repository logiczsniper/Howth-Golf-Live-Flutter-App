import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bar_custom.dart';
import 'package:howth_golf_live/custom_elements/app_drawer.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class SimplePage extends StatelessWidget with AppResources {
  final Center Function() _buildBody;
  final String title;
  SimplePage(this._buildBody, this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: StandardAppBar(title),
      body: _buildBody(),
      backgroundColor: appTheme.primaryColor,
    );
  }
}
