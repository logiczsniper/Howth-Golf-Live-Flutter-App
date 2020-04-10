import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/complex_score.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:howth_golf_live/app/firebase_view_model.dart';

class SideFlexible extends StatelessWidget {
  final int id;
  final bool isHowth;
  final GlobalKey childKey;
  final String description;

  /// Shows the overall competition score, [field] for a specific competition.
  SideFlexible(this.id, this.isHowth, this.childKey, this.description);

  /// The maroon decoration around the [field].
  Decoration get _decoration => ShapeDecoration(
      color: Palette.light,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)));

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: <Widget>[
            UIToolkit.showcase(
              context: context,
              key: childKey,
              description: description,
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: _decoration,
                child: Selector<FirebaseViewModel, String>(
                  selector: (_, model) => isHowth
                      ? model.entryFromId(id).score.howth
                      : model.entryFromId(id).score.opposition,
                  builder: (context, scoreString, _) => AnimatedSwitcher(
                    duration: Duration(milliseconds: 350),
                    child: RichText(
                      key: ValueKey<String>(scoreString),
                      text: ComplexScore.getMixedFraction(scoreString),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}
