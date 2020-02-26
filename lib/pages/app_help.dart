import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/help_data.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:howth_golf_live/presentation/utils.dart';

import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/my_details.dart';
import 'package:howth_golf_live/pages/unique/help.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/domain/privileges.dart';

class HelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  bool hasAccess;

  static Text _getLeadingText(String text) => Text(text,
      overflow: TextOverflow.fade,
      maxLines: 1,
      style: UIToolkit.leadingChildTextStyle);

  static Widget _tileBuilder(
          BuildContext context, AppHelpEntry currentHelpEntry, int index) =>
      ComplexCard(
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
              leading: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Container(
                      padding: EdgeInsets.only(right: 15.0),
                      decoration: UIToolkit.rightSideBoxDecoration,
                      child: _getLeadingText(index.toString()))),
              title: Text(
                currentHelpEntry.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(currentHelpEntry.subtitle,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: UIToolkit.cardSubTitleTextStyle),
              trailing: Icon(Icons.keyboard_arrow_right)),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SpecificHelpPage(currentHelpEntry)));
          });

  void _onComplete(Future<bool> isVerified) => setState(() {
        isVerified.then((bool result) => hasAccess = result);
      });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Privileges arguments = ModalRoute.of(context).settings.arguments;

    List<String> competitionAccess = arguments.competitionAccess ?? [];

    if (hasAccess == null) {
      hasAccess = arguments.isAdmin ?? false;
    }

    return Scaffold(
      appBar: CodeFieldBar(
          Strings.helpText, Privileges.adminAttempt, _onComplete, hasAccess),
      body: OpacityChangeWidget(
        target: ListView.builder(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
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
                Utils.bonusEntries(competitionAccess, hasAccess)),
      ),
    );
  }
}
