import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:howth_golf_live/custom_elements/list_tile.dart';
import 'package:howth_golf_live/custom_elements/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/custom_elements/complex_card.dart';
import 'package:howth_golf_live/custom_elements/opacity_change.dart';
import 'package:howth_golf_live/custom_elements/my_details.dart';
import 'package:howth_golf_live/pages/specific_pages/help.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';

class AppHelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppHelpPageState();
}

class AppHelpPageState extends State<AppHelpPage> {
  static Text _getLeadingText(String text) {
    return Text(text,
        overflow: TextOverflow.fade,
        maxLines: 1,
        style: Constants.leadingChildTextStyle);
  }

  static Widget _tileBuilder(
      BuildContext context, AppHelpEntry currentHelpEntry, int index) {
    return ComplexCard(
        child: BaseListTile(
            leadingChild: _getLeadingText(index.toString()),
            trailingWidget: Icon(Icons.keyboard_arrow_right,
                color: Constants.primaryAppColorDark),
            subtitleMaxLines: 2,
            subtitleText: currentHelpEntry.subtitle,
            titleText: currentHelpEntry.title),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SpecificHelpPage(currentHelpEntry)));
        });
  }

  bool applyPrivileges(String codeAttempt) {
    if (codeAttempt == '1234') {
      // TODO: change the code
      final preferences = SharedPreferences.getInstance();
      preferences.then((SharedPreferences preferences) {
        preferences.setBool(Constants.activeAdminText, true);
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Privileges arguments = ModalRoute.of(context).settings.arguments;
    final bool isInitVerified =
        arguments.isAdmin == null ? false : arguments.isAdmin;
    return Scaffold(
      appBar:
          CodeFieldBar(Constants.appHelpText, applyPrivileges, isInitVerified),
      body: OpacityChangeWidget(
        target: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              /// At the top of the list, [MyDetails] are displayed.
              if (index == 0) {
                return MyDetails();
              }
              AppHelpEntry currentHelpEntry =
                  Constants.appHelpEntries[index - 1];
              return _tileBuilder(context, currentHelpEntry, index);
            },
            itemCount: Constants.appHelpEntries.length + 1),
      ),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
