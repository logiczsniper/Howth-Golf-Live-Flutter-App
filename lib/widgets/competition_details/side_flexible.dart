import 'package:flutter/widgets.dart';

import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';

class SideFlexible extends StatelessWidget {
  final Score score;
  final bool condition;

  /// Shows the overall competition score, [text] for a specific competition.
  const SideFlexible(this.score, this.condition);

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
            child: AnimatedSwitcher(
                child: ComplexScore.getMixedFraction(condition, score),
                duration: Duration(milliseconds: 350)),
            decoration: _decoration)
      ]));
}
