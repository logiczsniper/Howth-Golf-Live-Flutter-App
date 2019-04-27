import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_fading_element.dart';
import 'package:howth_golf_live/pages/parents/complex_page.dart';

class ResultsPage extends ComplexPage {
  static Widget tileBuilder(int index, List filteredElements) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${filteredElements[index]['title']}",
                style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 187, 187, 187),
                    fontWeight: FontWeight.w300),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
              ),
              SizedBox(
                  width: 290,
                  child: Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: new BorderSide(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 153, 0, 0)))))),
              Padding(
                padding: EdgeInsets.only(top: 6),
              )
            ]),
        subtitle: Text(
            "${filteredElements[index]['date']} by ${filteredElements[index]['author']}",
            style: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 187, 187, 187))),
        trailing: FadingElement(
          Icon(Icons.keyboard_arrow_right,
              color: Color.fromARGB(255, 187, 187, 187)),
          false,
          duration: Duration(milliseconds: 800),
        ));
  }

  ResultsPage() : super(tileBuilder, "Results");
}
