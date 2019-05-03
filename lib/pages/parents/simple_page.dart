import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bar.dart';
import 'package:howth_golf_live/custom_elements/app_drawer.dart';
import 'package:howth_golf_live/custom_elements/styled_card.dart';
import 'package:howth_golf_live/static/constants.dart';

class SimplePage extends StatelessWidget {
  final Center Function() _buildBody;
  final String title;
  SimplePage(this._buildBody, this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: StandardAppBar(title),
      body: StyledCard(
        ListTile(
          title: _buildBody(),
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
        ),
        simple: true
      ),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
