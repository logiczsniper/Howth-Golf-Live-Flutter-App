import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  StandardAppBar(this.title, {Key key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize; //

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title:
          Text(title, style: TextStyle(color: Constants.primaryAppColorDark)),
      backgroundColor: Constants.primaryAppColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
    );
  }
}
