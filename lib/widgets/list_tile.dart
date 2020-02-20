import 'package:flutter/material.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class BaseListTile extends StatelessWidget {
  final Widget leadingChild;
  final IconData trailingIconData;
  final bool threeLine;
  final String titleText;
  final int subtitleMaxLines;
  final String subtitleText;

  /// A special [ListTile] with padding and decoration,
  /// and formated text.
  BaseListTile(
      {this.leadingChild,
      this.titleText,
      this.threeLine = false,
      this.subtitleMaxLines,
      this.subtitleText,
      this.trailingIconData});

  @override
  Widget build(BuildContext context) => ListTile(
      isThreeLine: threeLine,
      contentPadding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
      leading: Container(
          padding: EdgeInsets.only(right: 15.0),
          decoration: UIToolkit.rightSideBoxDecoration,
          child: leadingChild),
      title: Text(
        titleText,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: Text(subtitleText,
          overflow: TextOverflow.fade,
          maxLines: subtitleMaxLines,
          style: UIToolkit.cardSubTitleTextStyle),
      trailing: Icon(trailingIconData));
}
