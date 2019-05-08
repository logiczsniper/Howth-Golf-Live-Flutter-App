import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bar.dart';
import 'package:howth_golf_live/static/constants.dart';

class SpecificCompetitionPage extends StatelessWidget {
  final Map data;

  SpecificCompetitionPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(data['title']),
      body: Column(
        children: <Widget>[
          Center(
              child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.location_on),
                  Text(
                    data['location'],
                    style: Constants.cardSubTitleTextStyle,
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Text(
                        data['time'],
                        style: Constants.cardSubTitleTextStyle,
                      ),
                    ],
                  )),
            ],
          )),
          Padding(
            padding: EdgeInsets.all(20.0),
          ),
          ListTile(
            leading: Container(
                margin: EdgeInsets.fromLTRB(50.0, 1.0, 1.0, 1.0),
                child: Column(
                  children: <Widget>[
                    Text('Howth GC', style: Constants.cardTitleTextStyle),
                    Container(
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.all(1.0),
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
            title: Container(
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          width: 1.5, color: Constants.accentAppColor),
                      left: BorderSide(
                          width: 1.5, color: Constants.accentAppColor))),
              height: 50.0,
            ),
            trailing: Container(
                margin: EdgeInsets.fromLTRB(1.0, 1.0, 50.0, 1.0),
                child: Column(
                  children: <Widget>[
                    Text(data['opposition'],
                        style: Constants.cardTitleTextStyle),
                    Container(
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.all(1.0),
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
                )),
          ), /* TODO List builder here */
        ],
      ),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
