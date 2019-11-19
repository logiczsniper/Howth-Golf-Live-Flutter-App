import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:howth_golf_live/static/constants.dart';

class MyDetails extends StatelessWidget {
  /// A red border with rounded corners.
  BoxDecoration _getBorder() {
    return BoxDecoration(
        border: Border.all(color: Constants.accentAppColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)));
  }

  /// My (contextual) contact details, styled.
  Text _getText() {
    return Text(
      'Contact the developer:\nhowth.lczernel@gmail.com',
      style: Constants.cardSubTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 65.0, vertical: 5.0),
        padding: EdgeInsets.all(7.0),
        decoration: _getBorder(),
        child: Column(
          children: <Widget>[
            Icon(Icons.contact_mail, color: Constants.primaryAppColorDark),
            _getText()
          ],
        ));
  }
}
