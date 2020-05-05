import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/style/text_styles.dart';

/// Shows an icon, [icon] followed by a value of the competition, [field].
/// The competition is specified by the [id].
class MiddleRow extends StatelessWidget {
  final String field;
  final int id;
  final Icon icon;

  const MiddleRow(this.field, this.icon, this.id);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Flexible(
            child: Selector<FirebaseViewModel, String>(
              selector: (_, model) => model.entryFromId(id).attribute(field),
              builder: (context, value, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(
                  value,
                  key: ValueKey<String>(value),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.cardSubTitle.apply(fontSizeDelta: -1),
                ),
              ),
            ),
          ),
        ],
      );
}
