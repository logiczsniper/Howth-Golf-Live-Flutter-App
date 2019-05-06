import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bar.dart';
import 'package:howth_golf_live/custom_elements/app_drawer.dart';
import 'package:howth_golf_live/custom_elements/simple_card.dart';
import 'package:howth_golf_live/static/constants.dart';

class SimplePage extends StatelessWidget {
  final List<Widget> Function(ScrollController) _buildBody;
  final String title;
  SimplePage(this._buildBody, this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = new ScrollController();
    return Scaffold(
      drawer: AppDrawer(),
      appBar: StandardAppBar(title),
      body: SimpleCard(ListTile(
        title: Center(
          child: ListView(children: _buildBody(_controller)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 7.0),
      )),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
