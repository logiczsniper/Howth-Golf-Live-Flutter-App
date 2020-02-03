import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isVerified;

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

  Future<bool> _applyPrivileges(String codeAttempt) {
    /// Fetch the admin code from the database.
    return Future<bool>.value(
        Toolkit.stream.first.then((QuerySnapshot snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.documents.elementAt(0);
      int adminCode = documentSnapshot.data['admin_code'];

      if (codeAttempt == adminCode.toString()) {
        final preferences = SharedPreferences.getInstance();
        preferences.then((SharedPreferences preferences) {
          preferences.setBool(Toolkit.activeAdminText, true);
        });
        setState(() {
          isVerified = true;
        });
        return true;
      }
      setState(() {
        isVerified = false;
      });
      return false;
    }));
  }

  /// If they have special privileges, display extra entries depending on
  /// their access level.
  int _bonusEntries(List<String> competitionAccess, bool isAdmin) {
    if (isAdmin)
      return 2;
    else if (competitionAccess.isNotEmpty)
      return 1;
    else
      return 0;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Privileges arguments = ModalRoute.of(context).settings.arguments;
    List<String> competitionAccess = arguments.competitionAccess ?? [];
    if (isVerified == null) {
      isVerified = arguments.isAdmin ?? false;
    }

    return Scaffold(
      appBar: CodeFieldBar(Toolkit.helpText, _applyPrivileges, isVerified),
      body: OpacityChangeWidget(
        target: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              /// At the top of the list, [MyDetails] are displayed.
              if (index == 0) return MyDetails();

              AppHelpEntry currentHelpEntry = HelpData.entries[index - 1];
              return _tileBuilder(context, currentHelpEntry, index);
            },

            /// The [itemCount] must change depending on the user's
            /// privileges.
            ///
            /// If they have higher access, add X to [itemCount],
            /// where X is the number of entries specific to higher
            /// privilege tasks of their level.
            ///
            /// Normally, 1 would be added to the length of the entries to account
            /// for [MyDetails] widget. However, the number of higher access entries
            /// must be subtracted before the bonus entries are added.
            itemCount: HelpData.entries.length -
                1 +
                _bonusEntries(competitionAccess, isVerified)),
      ),
      backgroundColor: Palette.light,
    );
  }
}
