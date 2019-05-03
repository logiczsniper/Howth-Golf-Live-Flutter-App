import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/fading_element.dart';
import 'package:howth_golf_live/pages/parents/complex_page.dart';
import 'package:howth_golf_live/static/constants.dart';

class CompetitionsPage extends ComplexPage {
  static Widget tileBuilder(int index, List filteredElements) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
        leading: Padding(
            padding: EdgeInsets.only(top: 4),
            child: Container(
              padding: EdgeInsets.only(right: 15.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(
                          width: 1.5, color: Constants.accentAppColor))),
              child: Text(
                  "${filteredElements[index]['score']['howth_score']} - ${filteredElements[index]['score']['opposition_score']}",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 19,
                      color: Constants.primaryAppColorDark,
                      fontWeight: FontWeight.w400)),
            )),
        title: Text(
          "${filteredElements[index]['opposition']}",
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Constants.cardTitleTextStyle,
        ),
        subtitle: Text("${filteredElements[index]['start_date']}",
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

  CompetitionsPage() : super(tileBuilder, Constants.competitionsText);
}
