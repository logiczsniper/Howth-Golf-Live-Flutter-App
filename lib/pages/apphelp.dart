import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/parents/simple_page.dart';
import 'package:howth_golf_live/static/constants.dart';

class AppHelpPage extends SimplePage {
  static Center buildBody() {
    return Center(child: Text('App Help page'));
  }

  AppHelpPage({Key key}) : super(buildBody, Constants.appHelpText, key: key);
}
