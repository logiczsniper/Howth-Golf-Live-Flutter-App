import 'package:flutter/material.dart';
import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:provider/provider.dart';

typedef UpdateHole = Hole Function(Hole);

/// A pair of [IconButton]s in a column, one with a plus icon
/// and one with a subtract icon.
///
/// These buttons are for [Hole] data manipulation, which hole is
/// specified by the competition [id] and the hole [index] in the list of
/// holes.
///
/// When the add button is hit, [onAdd] is run.
/// When the subtract button is hit, [onSubtract] is run.
class IconButtonPair extends StatelessWidget {
  final BuildContext context;
  final int id;
  final int index;
  final Color iconColor;
  final UpdateHole onAdd;
  final UpdateHole onSubtract;

  const IconButtonPair(
    this.context,
    this.index,
    this.id, {
    this.iconColor = Palette.dark,
    @required this.onAdd,
    @required this.onSubtract,
  });

  /// Uses [FirebaseInteraction] to modify the [Hole] data.
  void tapped(Hole Function(Hole) callback) {
    /// Fetch the [currentHole] from the [Provider].
    var _firebaseModel = Provider.of<FirebaseViewModel>(context, listen: false);
    Hole currentHole = _firebaseModel.entryFromId(id).holes.elementAt(index);

    /// Update the hole with the [callback].
    Hole updatedHole = callback(currentHole);

    /// Push change to database using [FirebaseInteraction.updateHole].
    FirebaseInteraction.of(context).updateHole(index, id, updatedHole);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 4.0, left: 0.5, right: 0.5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    tapped(onAdd);
                  },
                  child: Icon(
                    Icons.add_circle,
                    color: iconColor,
                    size: 34.0,
                  )),
              GestureDetector(
                  onTap: () {
                    tapped(onSubtract);
                  },
                  child: Icon(
                    Icons.remove_circle,
                    size: 31.5,
                    color: iconColor.withAlpha(245),
                  )),
            ]));
  }
}
