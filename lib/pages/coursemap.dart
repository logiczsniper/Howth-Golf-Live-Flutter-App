import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/styled_button.dart';
import 'package:howth_golf_live/pages/parents/simple_page.dart';
import 'package:howth_golf_live/static/constants.dart';

class ClubLinksPage extends SimplePage {
  static List<Widget> buildBody(ScrollController _controller) {
    return <Widget>[
      Text("Here are a few links that are associated with Howth Golf Club. \n ",
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          maxLines: 20,
          style: TextStyle(color: Constants.primaryAppColorDark, fontSize: 17)),
      StyledButton("https://www.howthgolfclub.ie/", "Howth Golf Club Website"),
      StyledButton(
          "http://www.brsgolf.com/howth/visitor_menu.php", "Book a Tea Time"),
      StyledButton("https://www.howthgolfclub.ie/members-log-in/",
          "Members Login on Website"),
      StyledButton("tel:+353 1 832 3055", "Call the Office"),
      StyledButton("tel:+353 (1)832 3055", "Call the Shop"),
    ];
  }

  ClubLinksPage({Key key})
      : super(buildBody, Constants.courseMapText, key: key);
}
