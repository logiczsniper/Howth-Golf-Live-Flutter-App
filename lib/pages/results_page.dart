import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/parents/complex_page.dart';

class ResultsPage extends ComplexPage {
  static List currentListBuilder() {
    return ['current', 'your', 'resultss'];
  }

  static List archivedListBuilder() {
    return ['archived', 'your', 'resultss'];
  }

  static List favouritesListBuilder() {
    return ['favourites', 'your', 'resultss'];
  }

  static ListTile tileBuilder(int index, List filteredElements) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
        leading: Container(
          padding: EdgeInsets.only(right: 15.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(
                      width: 1.5, color: Color.fromARGB(255, 153, 0, 0)))),
          child: Text("00 - 00",
              style: TextStyle(
                  fontSize: 26,
                  color: Color.fromARGB(255, 187, 187, 187),
                  fontWeight: FontWeight.w500)),
        ),
        title: Text(
          filteredElements[index].toString(),
          style: TextStyle(
              fontSize: 21,
              color: Color.fromARGB(255, 187, 187, 187),
              fontWeight: FontWeight.w300),
        ),
        subtitle: Text("00/00/0000 - 11/11/1111",
            style: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 187, 187, 187))),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: Color.fromARGB(255, 187, 187, 187)));
  }

  ResultsPage()
      : super(currentListBuilder, archivedListBuilder, favouritesListBuilder,
            tileBuilder, "Results");
}
