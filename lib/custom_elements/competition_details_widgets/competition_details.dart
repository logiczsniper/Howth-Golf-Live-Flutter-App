import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:howth_golf_live/custom_elements/competition_details_widgets/side_flexible.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:howth_golf_live/static/objects.dart';

import 'middle_row.dart';

class CompetitionDetails extends StatelessWidget {
  final DataBaseEntry data;
  CompetitionDetails(this.data);

  MiddleRow _getMiddleRow(String data, IconData iconData, double size) {
    return MiddleRow(
        data, Icon(iconData, size: size, color: Toolkit.primaryAppColorDark));
  }

  Flexible _getCentralFlexible() {
    return Flexible(
      flex: 2,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _getMiddleRow(data.opposition, FontAwesomeIcons.fistRaised, 15.5),
          _getMiddleRow(data.location, Icons.location_on, 18.5),
          _getMiddleRow(data.time, Icons.access_time, 18)
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 1.5, 0.0, 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SideFlexible(data.score.howth),
          _getCentralFlexible(),
          SideFlexible(data.score.opposition)
        ],
      ),
    );
  }
}
