import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';

class CompetitionDetails extends StatelessWidget {
  final DataBaseEntry data;
  CompetitionDetails(this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
            flex: 1,
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(data.score.howth,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 21,
                            color: Constants.primaryAppColorDark,
                            fontWeight: FontWeight.w400)),
                    decoration: ShapeDecoration(
                        color: Constants.accentAppColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
              ],
            )),
        Flexible(
          flex: 2,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.fistRaised,
                    size: 15.5,
                  ),
                  Container(
                      child: Text(
                    data.opposition,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: Constants.cardSubTitleTextStyle
                        .apply(fontSizeDelta: -2),
                  ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 18.5,
                  ),
                  Container(
                      child: Text(
                    data.location,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: Constants.cardSubTitleTextStyle
                        .apply(fontSizeDelta: -2),
                  ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    size: 18.0,
                  ),
                  Container(
                      child: Text(
                    data.time,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: Constants.cardSubTitleTextStyle
                        .apply(fontSizeDelta: -2),
                  )),
                ],
              ),
            ],
          )),
        ),
        Flexible(
            flex: 1,
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(data.score.opposition,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 21,
                            color: Constants.primaryAppColorDark,
                            fontWeight: FontWeight.w400)),
                    decoration: ShapeDecoration(
                        color: Constants.accentAppColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
              ],
            ))
      ],
    );
  }
}
