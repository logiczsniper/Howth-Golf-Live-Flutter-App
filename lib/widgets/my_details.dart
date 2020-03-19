import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:howth_golf_live/constants/strings.dart';

import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';

class MyDetails extends StatelessWidget {
  /// A red border with rounded corners.
  static BoxDecoration get _border => BoxDecoration(
      border: Border.all(color: Palette.maroon, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(13.0)));

  /// My (contextual) contact details, styled.
  static Text get _text => Text(
        Strings.contactDeveloper,
        style: TextStyles.cardSubTitle,
        textAlign: TextAlign.center,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 65.0, vertical: 5.0),
        padding: EdgeInsets.all(7.0),
        decoration: _border,
        child: Column(
          children: <Widget>[Icon(Icons.contact_mail), _text],
        ));
  }
}
