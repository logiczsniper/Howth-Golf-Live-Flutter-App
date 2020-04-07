import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/widgets/competition_details/middle_row.dart';
import 'package:howth_golf_live/widgets/competition_details/side_flexible.dart';

class CompetitionDetails extends StatelessWidget {
  final DatabaseEntry currentEntry;
  final GlobalKey howthScoreKey;
  final GlobalKey oppositionScoreKey;
  final GlobalKey locationKey;
  final GlobalKey dateKey;
  final GlobalKey timeKey;

  CompetitionDetails(this.currentEntry, this.howthScoreKey,
      this.oppositionScoreKey, this.locationKey, this.dateKey, this.timeKey);

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
  Widget _centralFlexible(BuildContext context, bool hasAccess) => Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            UIToolkit.showcase(
              context: context,
              key: locationKey,
              description: Strings.location,
              child: _getMiddleRow(
                  currentEntry.location.address, Icons.location_on, 18.5),
            ),
            UIToolkit.showcase(
              context: context,
              key: dateKey,
              description: Strings.date,
              child: _getMiddleRow(currentEntry.date, Icons.date_range, 18.0),
            ),
            UIToolkit.showcase(
              context: context,
              key: timeKey,
              description: Strings.time,
              child: _getMiddleRow(currentEntry.time, Icons.access_time, 18),
            ),
            hasAccess
                ? _getMiddleRow(currentEntry.id.toString(), Icons.vpn_key, 17.0)
                : Container()
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);
    bool hasAccess =
        _userStatus.isVerified(currentEntry.title, id: currentEntry.id);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.5),
      padding: EdgeInsets.fromLTRB(0.0, 3.5, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /// Home team score.
          SideFlexible(
              currentEntry.score, true, howthScoreKey, Strings.howthScore),

          /// Details of competition.
          Flexible(child: _centralFlexible(context, hasAccess)),

          /// Away team score.
          SideFlexible(
            currentEntry.score,
            false,
            oppositionScoreKey,
            Strings.oppositionScore,
          )
        ],
      ),
    );
  }
}
