import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:howth_golf_live/custom_elements/competition_details_widgets/side_flexible.dart';
import 'package:howth_golf_live/static/objects.dart';

import 'middle_row.dart';


class CompetitionDetails extends StatelessWidget {
  final DataBaseEntry data;
  CompetitionDetails(this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SideFlexible(data.score.howth),
        Flexible(
          flex: 2,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MiddleRow(
                  data.opposition,
                  Icon(
                    FontAwesomeIcons.fistRaised,
                    size: 15.5,
                  )),
              MiddleRow(
                  data.location,
                  Icon(
                    Icons.location_on,
                    size: 18.5,
                  )),
              MiddleRow(
                  data.time,
                  Icon(
                    Icons.access_time,
                    size: 18.0,
                  )),
            ],
          )),
        ),
        SideFlexible(data.score.opposition)
      ],
    );
  }
}