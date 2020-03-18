import 'package:flutter/widgets.dart';

import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class SideFlexible extends StatelessWidget {
  final Score score;
  final bool condition;
  final childKey;
  final String description;

  /// Shows the overall competition score, [text] for a specific competition.
  SideFlexible(this.score, this.condition, this.childKey, this.description);

  /// The maroon decoration around the [text].
  Decoration get _decoration => ShapeDecoration(
      color: Palette.maroon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));

  @override
  Widget build(BuildContext context) => Flexible(
      flex: 1,
      child: Column(children: <Widget>[
        UIToolkit.showcase(
            context: context,
            key: childKey,
            description: description,
            child: Container(
                padding: EdgeInsets.all(12.0),
                child: AnimatedSwitcher(
                    child: ComplexScore.getMixedFraction(condition, score),
                    duration: Duration(milliseconds: 350)),
                decoration: _decoration))
      ]));
}
