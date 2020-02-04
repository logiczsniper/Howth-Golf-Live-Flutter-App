import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/static/palette.dart';

class SideFlexible extends StatelessWidget {
  final String score;

  /// Shows the overall competition score, [text] for a specific competition.
  const SideFlexible(this.score);

  Text get _text => Text(score,
      overflow: TextOverflow.fade,
      maxLines: 1,
      style: TextStyle(
          fontSize: 21, color: Palette.dark, fontWeight: FontWeight.w400));

  /// The maroon decoration around the [text].
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
