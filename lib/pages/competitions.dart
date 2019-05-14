import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/fading_element.dart';
import 'package:howth_golf_live/pages/parents/complex_page.dart';
import 'package:howth_golf_live/static/constants.dart';

class CompetitionsPage extends ComplexPage {
  static Widget tileBuilder(int index, List filteredElements) {
    var base = filteredElements[index];
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
                  "${base['score']['howth']} - ${base['score']['opposition']}",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 20,
                      color: Constants.primaryAppColorDark,
                      fontWeight: FontWeight.w400)),
            )),
        title: Text(
          "${base['title']}",
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Constants.cardTitleTextStyle,
        ),
        subtitle: Text("${base['date']}",
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
