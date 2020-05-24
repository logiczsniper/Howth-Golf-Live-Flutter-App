import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'package:howth_golf_live/app/help/help_data_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/style/palette.dart';

import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/complex_card.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class HelpsPage extends StatelessWidget {
  /// Build a tile in the page.
  static Widget _tileBuilder(
    BuildContext context,
    AppHelpEntry currentHelpEntry,
    int index,
  ) =>
      ComplexCard(
        onTap: () => Routes.of(context).toHelp(currentHelpEntry),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 13.0,
            vertical: 5.0,
          ),
          title: Text(
            currentHelpEntry.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          subtitle: Text(
            currentHelpEntry.subtitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyles.cardSubTitle,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Palette.maroon,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    /// This page is not that expensive to rebuild and will not rebuild
    /// frequently, its okay to listen to both [HelpDataViewModel] and
    /// [UserStatusViewModel]. The [UserStatusViewModel] must be listened to
    /// regardless to account for the new entries being added if the user
    /// becomes an admin.
    var _helpData = Provider.of<HelpDataViewModel>(context);
    var _userStatus = Provider.of<UserStatusViewModel>(context);

    /// Showcase keys.
    final GlobalKey _backKey = GlobalKey();
    final GlobalKey _codeKey = GlobalKey();

    List<GlobalKey> keys = [_codeKey, _backKey];

    /// If the user has not visited this page before,
    /// start the showcase.
    if (!_userStatus.hasVisited(Strings.helpsText)) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(
          const Duration(milliseconds: 650),
          () => ShowCaseWidget.of(context).startShowCase(keys),
        ),
      );
    }

    return Scaffold(
      appBar: CodeFieldBar(Strings.helpsText, _backKey, _codeKey),
      body: _helpData.data.isEmpty
          ? UIToolkit.loadingSpinner
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 100.0),
              itemCount: _helpData.data.length + _userStatus.bonusHelpEntries,
              itemBuilder: (context, index) {
                AppHelpEntry currentHelpEntry = _helpData.data[index];
                return _tileBuilder(context, currentHelpEntry, index + 1);
              },
            ),
    );
  }
}
