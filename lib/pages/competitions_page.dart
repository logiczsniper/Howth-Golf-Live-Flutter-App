import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_fading_element.dart';
import 'package:howth_golf_live/pages/parents/complex_page.dart';

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
                          width: 1.5, color: Color.fromARGB(255, 153, 0, 0)))),
              child: Text(
                  "${filteredElements[index]['score']['howth_score']} - ${filteredElements[index]['score']['opposition_score']}",
                  style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontWeight: FontWeight.w500)),
            )),
        title: Text(
          "${filteredElements[index]['opposition']}",
          style: TextStyle(
              fontSize: 19,
              color: Color.fromARGB(255, 187, 187, 187),
              fontWeight: FontWeight.w300),
        ),
        subtitle: Text("${filteredElements[index]['start_date']}",
            style: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 187, 187, 187))),
        trailing: FadingElement(
          Icon(Icons.keyboard_arrow_right,
              color: Color.fromARGB(255, 187, 187, 187)),
          false,
          duration: Duration(milliseconds: 800),
        ));
  }

  CompetitionsPage() : super(tileBuilder, "Competitions");
}
