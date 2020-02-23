import 'package:flutter/material.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class BaseListTile extends StatelessWidget {
  final Widget leadingChild;
  final IconData trailingIconData;
  final bool threeLine;
  final String titleText;
  final int subtitleMaxLines;
  final String subtitleText;
  final int index;

  /// A special [ListTile] with padding and decoration,
  /// and formated text.
  BaseListTile(
      {@required this.leadingChild,
      @required this.titleText,
      this.threeLine = false,
      @required this.subtitleMaxLines,
      @required this.subtitleText,
      @required this.trailingIconData,
      @required this.index});

  /// TODO: remove this widget, only used for competitions,
  /// use old base list tile for app help!
  @override
  Widget build(BuildContext context) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
      title: Text(
        titleText,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: Row(children: <Widget>[
        Container(
            padding: EdgeInsets.only(right: 15.0),
            decoration: UIToolkit.rightSideBoxDecoration,
            child: Text(subtitleText,
                overflow: TextOverflow.fade,
                maxLines: subtitleMaxLines,
                style: UIToolkit.cardSubTitleTextStyle)),
        Padding(
          child: leadingChild,
          padding: EdgeInsets.only(left: 15.0),
        )
      ]),
      trailing: Icon(trailingIconData));
}
