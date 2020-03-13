import 'package:flutter/material.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/services/utils.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/app/hole/hole_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class HolePage extends StatelessWidget {
  final int id;
  final int index;

  HolePage(this.id, this.index);

  Flexible _getScore(Widget _teamScore) => Flexible(
      child: Container(
          padding: EdgeInsets.all(12.0),
          child: AnimatedSwitcher(
              child: _teamScore, duration: Duration(milliseconds: 350)),
          decoration: UIToolkit.scoreDecoration));

  Text _getScoreText(bool condition, Score score) =>
      Text(condition ? score.howth : score.opposition,
          key: ValueKey(DateTime.now()),
          style: TextStyle(
              fontSize: 21,
              color: Palette.inMaroon,
              fontWeight: FontWeight.w400));

  Text _getLastUpdated(HoleViewModel holeModel, DateTime lastUpdated) =>
      Text(holeModel.prettyLastUpdated(lastUpdated),
          textAlign: TextAlign.center,
          style: TextStyles.cardTitleTextStyle,
          key: ValueKey(DateTime.now()));

  Widget _getScoreButtons(BuildContext context, Hole hole,
          Score incrementedScore, Score decrementedScore, bool hasAccess) =>
      hasAccess
          ? Column(children: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Hole updatedHole =
                        hole.updateHole(newScore: incrementedScore);
                    FirebaseInteration(context)
                        .updateHole(index, id, updatedHole);
                  }),
              IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    Hole updatedHole =
                        hole.updateHole(newScore: decrementedScore);
                    FirebaseInteration(context)
                        .updateHole(index, id, updatedHole);
                  })
            ])
          : Container();

  Widget _getHoleButtons(BuildContext context, Hole hole, IconData iconData,
      int value, bool hasAccess) {
    assert(value == 1 || value == -1);
    return hasAccess
        ? IconButton(
            icon: Icon(iconData),
            onPressed: () {
              /// Apply value of one or minus one to the [holeNumber].
              Hole updatedHole = hole.updateNumber(value);
              FirebaseInteration(context).updateHole(index, id, updatedHole);
            })
        : Padding(padding: EdgeInsets.only(top: 50.0));
  }

  @override
  Widget build(BuildContext context) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);
    var _holeModel = Provider.of<HoleViewModel>(context);

    bool hasAccess = _userStatus.isVerified(Strings.specificHole, id: id);
    bool isHome = _holeModel.isHome(id);
    Hole hole = _holeModel.hole(id, index);

    Text homeScoreText = _getScoreText(isHome, hole.holeScore);
    Text awayScoreText = _getScoreText(!isHome, hole.holeScore);
    Text lastUpdated = _getLastUpdated(_holeModel, hole.lastUpdated);

    Widget incrementHoleNumber =
        _getHoleButtons(context, hole, Icons.add, 1, hasAccess);
    Widget decrementHoleNumber =
        _getHoleButtons(context, hole, Icons.remove, -1, hasAccess);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(Strings.specificHole,
              textAlign: TextAlign.center, maxLines: 2),
          actions: <Widget>[
            hasAccess
                ? IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    tooltip: Strings.deleteHole,
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                            FirebaseInteration(context).deleteHole,
                            index: index,
                            id: id)))
                : UIToolkit.getHomeButton(context)
          ]),
      body: Padding(
          padding: EdgeInsets.all(5.0),
          child:
              UIToolkit.getCard(ListView(shrinkWrap: true, children: <Widget>[
            hasAccess
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              /// Edit the home team score.

              /// If howth [isHome], then add one to howth score as howth
              /// is the home team!
              ///
              /// Otherwise, remove one from the home team!
              _getScoreButtons(
                  context,
                  hole,
                  hole.holeScore.updateScore(isHome, 1),
                  hole.holeScore.updateScore(isHome, -1),
                  hasAccess),

              _getScore(homeScoreText),

              Text(
                " - ",
                style: TextStyles.leadingChildTextStyle,
              ),

              _getScore(awayScoreText),

              /// Edit the away team score.

              /// If add one or remove one from the away team score!
              _getScoreButtons(
                  context,
                  hole,
                  hole.holeScore.updateScore(!isHome, 1),
                  hole.holeScore.updateScore(!isHome, -1),
                  hasAccess),
            ]),
            UIToolkit.getVersus(isHome, _holeModel.opposition(id),
                Utils.formatPlayers(hole.players)),

            /// Edit the hole number.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                incrementHoleNumber,

                /// Hole Number
                AnimatedSwitcher(
                  child: UIToolkit.getHoleNumberDecorated(hole.holeNumber),
                  duration: Duration(milliseconds: 300),
                ),

                decrementHoleNumber,
              ],
            ),

            /// Display the [lastUpdated] formatted.
            Container(
                padding:
                    hole.comment.isEmpty ? EdgeInsets.only(bottom: 8.0) : null,
                child: AnimatedSwitcher(
                  child: lastUpdated,
                  duration: Duration(milliseconds: 350),
                )),

            /// If there is a [comment], display it.
            hole.comment.isEmpty
                ? Container()
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      "Comment: ${hole.comment}",
                      textAlign: TextAlign.center,
                      style: TextStyles.cardTitleTextStyle,
                    ))
          ]))),
    );
  }
}
