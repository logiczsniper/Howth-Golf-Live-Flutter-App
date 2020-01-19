import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/static/palette.dart';

class SideFlexible extends StatelessWidget {
  final String text;

  const SideFlexible(this.text);

  Text get _text => Text(text,
      overflow: TextOverflow.fade,
      maxLines: 1,
      style: TextStyle(
          fontSize: 21, color: Palette.dark, fontWeight: FontWeight.w400));

  Decoration get _decoration => ShapeDecoration(
      color: Palette.maroon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));

  @override
  Widget build(BuildContext context) => Flexible(
      flex: 1,
      child: Column(children: <Widget>[
        Container(
            padding: EdgeInsets.all(12.0),
            child: _text,
            decoration: _decoration)
      ]));
}
