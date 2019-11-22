import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<Widget> tileListBuilder(BuildContext context) {
    List<Widget> output = [MyDetails()];
    for (AppHelpEntry entry in Constants.appHelpEntries) {
      output.add(ComplexCard(
          // TODO: create builder methods for the widgets below (e.g. leading, title, etc)
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
            leading: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Container(
                  padding: EdgeInsets.only(right: 15.0),
                  decoration: Constants.rightSideBoxDecoration,
                  child: Text("${Constants.appHelpEntries.indexOf(entry) + 1}",
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 20,
                          color: Constants.primaryAppColorDark,
                          fontWeight: FontWeight.w400)),
                )),
            title: Text(
              entry.title,
              overflow: TextOverflow.fade,
              maxLines: 2,
              style: Constants.cardTitleTextStyle,
            ),
            subtitle: Text(entry.subtitle,
                overflow: TextOverflow.fade,
                maxLines: 2,
                style: Constants.cardSubTitleTextStyle),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Constants.primaryAppColorDark),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpecificHelpPage(entry)));
          }));
    }
    return output;
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
        target: ListView(
          children: tileListBuilder(context),
        ),
      ),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
