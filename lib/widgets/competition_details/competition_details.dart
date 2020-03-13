import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/widgets/competition_details/middle_row.dart';
import 'package:howth_golf_live/widgets/competition_details/side_flexible.dart';

class CompetitionDetails extends StatelessWidget {
  final DatabaseEntry currentEntry;

  CompetitionDetails(this.currentEntry);

  /// Get a padded [MiddleRow].
  ///
  /// Displays an icon followed by text ([data]).
  Widget _getMiddleRow(String data, IconData iconData, double size) {
    return Padding(
      child: MiddleRow(data.trim(), Icon(iconData, size: size)),
      padding: EdgeInsets.symmetric(vertical: 1.0),
    );
  }

  /// The central piece of a [CompetitionDetails].
  ///
  /// If [hasAccess], a fourth row must be displayed which shows the key ([id])
  /// of the competition.
  Widget _centralFlexible(bool hasAccess) => Flexible(
        flex: 2,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _getMiddleRow(
                currentEntry.location.address, Icons.location_on, 18.5),
            _getMiddleRow(currentEntry.date, Icons.date_range, 18.0),
            _getMiddleRow(currentEntry.time, Icons.access_time, 18),
            hasAccess
                ? _getMiddleRow(currentEntry.id.toString(), Icons.vpn_key, 17.0)
                : Container()
          ],
        )),
      );

  @override
  Widget build(BuildContext context) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);
    bool hasAccess =
        _userStatus.isVerified(currentEntry.title, id: currentEntry.id);

    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 1.5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// Home team score.
                SideFlexible(currentEntry.score, currentEntry.location.isHome),

                /// Details of competition.
                _centralFlexible(hasAccess),

                /// Away team score.
                SideFlexible(currentEntry.score, !currentEntry.location.isHome)
              ],
            ),
          ],
        ));
  }
}
