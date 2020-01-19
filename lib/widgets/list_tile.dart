import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class BaseListTile extends StatelessWidget {
  final Widget leadingChild;
  final IconData trailingIconData;
  final bool threeLine;
  final String titleText;
  final int subtitleMaxLines;
  final String subtitleText;

  BaseListTile(
      {this.leadingChild,
      this.titleText,
      this.threeLine = false,
      this.subtitleMaxLines,
      this.subtitleText,
      this.trailingIconData});

  @override
  Widget build(BuildContext context) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
      leading: Padding(
          padding: EdgeInsets.only(top: 4),
          child: Container(
              padding: EdgeInsets.only(right: 15.0),
              decoration: Toolkit.rightSideBoxDecoration,
              child: leadingChild)),
      title: Text(
        titleText,
        overflow: TextOverflow.fade,
        maxLines: 1,
        style: Toolkit.cardTitleTextStyle,
      ),
      subtitle: Text(subtitleText,
          overflow: TextOverflow.fade,
          maxLines: subtitleMaxLines,
          style: Toolkit.cardSubTitleTextStyle),
      trailing: Icon(trailingIconData, color: Palette.dark));
}
