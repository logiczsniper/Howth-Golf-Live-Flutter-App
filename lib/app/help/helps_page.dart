import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/help/help_data_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/text_styles.dart';

import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/my_details.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class HelpsPage extends StatelessWidget {
  static Text _getLeadingText(String text) => Text(text,
      overflow: TextOverflow.fade,
      maxLines: 1,
      style: TextStyles.leadingChildTextStyle);

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
                  style: TextStyles.cardSubTitleTextStyle),
              trailing: Icon(Icons.keyboard_arrow_right)),
          onTap: () => Routes.toHelp(context, currentHelpEntry));

  @override
  Widget build(BuildContext context) {
    var _helpData = Provider.of<HelpDataViewModel>(context);
    var _userStatus = Provider.of<UserStatusViewModel>(context);

    return Scaffold(
        appBar: CodeFieldBar(Strings.helpsText, _userStatus),
        body: OpacityChangeWidget(
            target: _helpData.data.length == 0
                ? UIToolkit.loadingSpinner
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
                    itemCount: _helpData.data.length + _userStatus.bonusEntries,
                    itemBuilder: (context, index) {
                      /// At the top of the list, [MyDetails] are displayed.
                      if (index == 0) return MyDetails();

                      AppHelpEntry currentHelpEntry = _helpData.data[index - 1];
                      return _tileBuilder(context, currentHelpEntry, index);
                    },
                  )));
  }
}
