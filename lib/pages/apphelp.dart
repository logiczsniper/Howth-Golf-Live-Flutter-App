import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/static/constants.dart';

class AppHelpPage extends StatelessWidget {
  List tileBuilder(BuildContext context) {
    List<Widget> output = [];
    return output;
  }

  void applyPrivileges(String codeAttempt) {
        if (codeAttempt == 'admin') {
          // TODO
      print('apply admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CodeFieldBar(
          {'title': Constants.appHelpText}, applyPrivileges),
      body: ListView(
        children: tileBuilder(context),
      ),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
