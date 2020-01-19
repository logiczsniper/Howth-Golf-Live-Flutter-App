import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/help_data.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:howth_golf_live/widgets/list_tile.dart';
import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/my_details.dart';
import 'package:howth_golf_live/pages/unique/help.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:howth_golf_live/static/privileges.dart';

class HelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  static Text _getLeadingText(String text) => Text(text,
      overflow: TextOverflow.fade,
      maxLines: 1,
      style: Toolkit.leadingChildTextStyle);

  static Widget _tileBuilder(
          BuildContext context, AppHelpEntry currentHelpEntry, int index) =>
      ComplexCard(
          child: BaseListTile(
              leadingChild: _getLeadingText(index.toString()),
              trailingIconData: Icons.keyboard_arrow_right,
              subtitleMaxLines: 2,
              subtitleText: currentHelpEntry.subtitle,
              titleText: currentHelpEntry.title),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpecificHelpPage(currentHelpEntry)));
          });

  bool _applyPrivileges(String codeAttempt) {
    if (codeAttempt == '1234') {
      // TODO: change the code
      final preferences = SharedPreferences.getInstance();
      preferences.then((SharedPreferences preferences) {
        preferences.setBool(Toolkit.activeAdminText, true);
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Privileges arguments = ModalRoute.of(context).settings.arguments;
    final bool isInitVerified = arguments.isAdmin ?? false;

    /// TODO: remove if this works, change others: arguments.isAdmin == null ? false : arguments.isAdmin;
    return Scaffold(
      appBar: CodeFieldBar(Toolkit.helpText, _applyPrivileges, isInitVerified),
      body: OpacityChangeWidget(
        target: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              /// At the top of the list, [MyDetails] are displayed.
              if (index == 0) return MyDetails();

              AppHelpEntry currentHelpEntry = HelpData.entries[index - 1];
              return _tileBuilder(context, currentHelpEntry, index);
            },
            itemCount: HelpData.entries.length + 1),
      ),
      backgroundColor: Palette.light,
    );
  }
}
