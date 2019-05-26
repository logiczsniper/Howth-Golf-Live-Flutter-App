import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/fading_element.dart';
import 'package:howth_golf_live/static/constants.dart';

class ResultsPage {
  static Widget tileBuilder(int index, List filteredElements) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${filteredElements[index]['title']}",
                style: Constants.cardTitleTextStyle,
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
              ),
              SizedBox(
                  width: 260,
                  child: Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: new BorderSide(
                                  width: 1.5,
                                  color: Constants.accentAppColor))))),
              Padding(
                padding: EdgeInsets.only(top: 6),
              )
            ]),
        subtitle: Text(
            "${filteredElements[index]['date']} by ${filteredElements[index]['author']}",
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: Constants.cardSubTitleTextStyle),
        trailing: FadingElement(
          Icon(Icons.keyboard_arrow_right,
              color: Constants.primaryAppColorDark),
          false,
          duration: Duration(milliseconds: 800),
        ));
  }
}
