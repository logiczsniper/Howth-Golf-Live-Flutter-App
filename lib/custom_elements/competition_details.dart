import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:howth_golf_live/static/constants.dart';

class CompetitionDetails extends StatelessWidget {
  final Map data;
  CompetitionDetails(this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width / 7,
            margin: EdgeInsets.all(1.0),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(data['score']['howth'],
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
        Container(
          height: MediaQuery.of(context).size.height / 14,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(2.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.fistRaised,
                    size: 16.0,
                  ),
                  Container(
                      child: Text(
                    data['opposition'],
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
                    data['location'],
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
                    data['time'],
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
        Container(
            width: MediaQuery.of(context).size.width / 7,
            margin: EdgeInsets.all(1.0),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(data['score']['opposition'],
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