import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/palette.dart';

import 'package:howth_golf_live/widgets/competition_details/middle_row.dart';
import 'package:howth_golf_live/widgets/competition_details/side_flexible.dart';

class CompetitionDetails extends StatelessWidget {
  final DataBaseEntry data;
  final bool hasAccess;
  CompetitionDetails(this.data, this.hasAccess);

  Widget _getMiddleRow(String data, IconData iconData, double size) {
    return Padding(
      child: MiddleRow(
          data.trim(), Icon(iconData, size: size, color: Palette.dark)),
      padding: EdgeInsets.symmetric(vertical: 1.0),
    );
  }

  Flexible get _centralFlexible => Flexible(
        flex: 2,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _getMiddleRow(data.opposition, FontAwesomeIcons.fistRaised, 14.7),
            _getMiddleRow(data.location, Icons.location_on, 18.5),
            _getMiddleRow(data.time, Icons.access_time, 18),
            hasAccess
                ? _getMiddleRow(data.id.toString(), Icons.vpn_key, 17.0)
                : Container()
          ],
        )),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(0.0, 1.5, 0.0, 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SideFlexible(data.score.howth),
            _centralFlexible,
            SideFlexible(data.score.opposition)
          ],
        ),
      );
}
