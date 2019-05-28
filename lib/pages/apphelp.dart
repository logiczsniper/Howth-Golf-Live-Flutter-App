import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/custom_elements/complex_card.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/fading_element.dart';
import 'package:howth_golf_live/custom_elements/my_details.dart';
import 'package:howth_golf_live/pages/specific_pages/help.dart';
import 'package:howth_golf_live/static/constants.dart';

class AppHelpPage extends StatelessWidget {
  List<Widget> tileListBuilder(BuildContext context) {
    List<Widget> output = [MyDetails()];
    for (Map<String, dynamic> entry in Constants.appHelpEntries) {
      output.add(ComplexCard(
          ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
              leading: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Container(
                    padding: EdgeInsets.only(right: 15.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.5, color: Constants.accentAppColor))),
                    child: Text(
                        "${Constants.appHelpEntries.indexOf(entry) + 1}",
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 20,
                            color: Constants.primaryAppColorDark,
                            fontWeight: FontWeight.w400)),
                  )),
              title: Text(
                "${entry['title']}",
                overflow: TextOverflow.fade,
                maxLines: 2,
                style: Constants.cardTitleTextStyle,
              ),
              subtitle: Text(entry['subtitle'],
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: Constants.cardSubTitleTextStyle),
              trailing: FadingElement(
                Icon(Icons.keyboard_arrow_right,
                    color: Constants.primaryAppColorDark),
                false,
                duration: Duration(milliseconds: 800),
              )), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SpecificHelpPage(entry)));
      }));
    }
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
      appBar: CodeFieldBar({'title': Constants.appHelpText}, applyPrivileges),
      body: ListView(
        children: tileListBuilder(context),
      ),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
