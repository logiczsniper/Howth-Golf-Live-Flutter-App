import 'package:flutter/material.dart';
import 'package:howth_golf_live/domain/models.dart';

import 'package:howth_golf_live/widgets/competition_details/middle_row.dart';
import 'package:howth_golf_live/widgets/competition_details/side_flexible.dart';

class CompetitionDetails extends StatelessWidget {
  final DataBaseEntry data;
  final bool hasAccess;
  CompetitionDetails(this.data, this.hasAccess);

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
  Widget get _centralFlexible => Flexible(
        flex: 2,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _getMiddleRow(data.location.address, Icons.location_on, 18.5),
            _getMiddleRow(data.date, Icons.date_range, 18.0),
            _getMiddleRow(data.time, Icons.access_time, 18),
            hasAccess
                ? _getMiddleRow(data.id.toString(), Icons.vpn_key, 17.0)
                : Container()
          ],
        )),
      );

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 1.5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /// Home team score.
              SideFlexible(data.score, data.location.isHome),

              /// Details of competition.
              _centralFlexible,

              /// Away team score.
              SideFlexible(data.score, !data.location.isHome)
            ],
          ),
        ],
      ));
}
