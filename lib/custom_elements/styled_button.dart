import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class StyledButton extends StatelessWidget {
  final String url;
  final String text;

  StyledButton(this.url, this.text);

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: RaisedButton(
            child: new Text(text),
            color: Constants.accentAppColor,
            textColor: Constants.primaryAppColorDark,
            onPressed: () {
              _launchUrl(url);
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0))));
  }
}
