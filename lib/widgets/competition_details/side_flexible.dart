import 'package:flutter/widgets.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';

class SideFlexible extends StatelessWidget {
  final Score scores;
  final bool condition;

  /// Shows the overall competition score, [text] for a specific competition.
  const SideFlexible(this.scores, this.condition);

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
                child: ComplexScore.getMixedFraction(condition, scores, scores),
                duration: Duration(seconds: 2)),
            decoration: _decoration)
      ]));
}
