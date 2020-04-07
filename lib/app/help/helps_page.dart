import 'package:flutter/material.dart';
import 'package:howth_golf_live/style/palette.dart';
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
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:showcaseview/showcase_widget.dart';

class HelpsPage extends StatelessWidget {
  static Widget _tileBuilder(
          BuildContext context, AppHelpEntry currentHelpEntry, int index) =>
      ComplexCard(
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
              title: Text(
                currentHelpEntry.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(currentHelpEntry.subtitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyles.cardSubTitle),
              trailing:
                  Icon(Icons.keyboard_arrow_right, color: Palette.maroon)),
          onTap: () => Routes.of(context).toHelp(currentHelpEntry));

  @override
  Widget build(BuildContext context) {
    var _helpData = Provider.of<HelpDataViewModel>(context);
    var _userStatus = Provider.of<UserStatusViewModel>(context);

    final GlobalKey _backKey = GlobalKey();
    final GlobalKey _codeKey = GlobalKey();

    List<GlobalKey> keys = [_codeKey, _backKey];

    if (!_userStatus.hasVisited(Strings.helpsText)) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase(keys));
    }

    return Scaffold(
        appBar:
            CodeFieldBar(Strings.helpsText, _userStatus, _backKey, _codeKey),
        body: OpacityChangeWidget(
            target: _helpData.data.isEmpty
                ? UIToolkit.loadingSpinner
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 100.0),
                    itemCount: _helpData.data.length + _userStatus.bonusEntries,
                    itemBuilder: (context, index) {
                      AppHelpEntry currentHelpEntry = _helpData.data[index];
                      return _tileBuilder(context, currentHelpEntry, index + 1);
                    },
                  )));
  }
}
