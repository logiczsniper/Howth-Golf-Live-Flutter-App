import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:howth_golf_live/domain/firebase_interation.dart';
import 'package:howth_golf_live/presentation/utils.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class HolePage extends StatefulWidget {
  final DataBaseEntry entry;
  final int index;
  final bool hasAccess;

  HolePage(this.entry, this.index, this.hasAccess);

  @override
  HolePageState createState() => HolePageState();
}

class HolePageState extends State<HolePage> {
  Hole hole;

  Widget _homeScore;
  Widget _awayScore;
  Widget _lastUpdated;

  /// Deletes the holes at the given [index] within the list of holes
  /// for this competition.
  /// TODO: put in presentation & logic layer? interact with services, no flutter UI?
  void _deleteHole() {
    final int currentId = widget.entry.id;
    Future<QuerySnapshot> newData = DataBaseInteraction.stream.first;

    newData.then((QuerySnapshot snapshot) => DataBaseInteraction.deleteHole(
        context, snapshot, widget.index, currentId));
  }

  /// Update the [currentHole].
  ///
  /// Can update the [holeScore], [holeNumber] or both. Also will
  /// update [lastUpdated] to now.
  /// TODO: PR&L first part
  void _updateHole(Hole currentHole, {Score newScore, int newHoleNumber}) {
    Hole updatedHole = Hole(
        holeNumber: newHoleNumber ?? currentHole.holeNumber,
        holeScore: newScore ?? currentHole.holeScore,
        players: currentHole.players,
        comment: currentHole.comment,
        lastUpdated: DateTime.now());

    final int currentId = widget.entry.id;
    Future<QuerySnapshot> newData = DataBaseInteraction.stream.first;

    newData.then((QuerySnapshot snapshot) => DataBaseInteraction.updateHole(
        context, snapshot, widget.index, currentId, updatedHole));

    setState(() {
      /// Rebuild with new data.
      Score oldScores = hole.holeScore;
      bool isHome = widget.entry.location.isHome;

      hole = updatedHole;

      _homeScore = _getScoreText(isHome, hole.holeScore, oldScores);
      _awayScore = _getScoreText(!isHome, hole.holeScore, oldScores);
      _lastUpdated = _getLastUpdated(hole.lastUpdated);
    });
  }

  Flexible _getScore(Widget _teamScore) => Flexible(
      child: Container(
          padding: EdgeInsets.all(12.0),
          child: AnimatedSwitcher(
              child: _teamScore, duration: Duration(milliseconds: 350)),
          decoration: UIToolkit.scoreDecoration));

  Text _getScoreText(bool condition, Score scores, Score oldScores) => Text(
        condition ? hole.holeScore.howth : hole.holeScore.opposition,
        key: scores.toString() == oldScores.toString()
            ? null
            : ValueKey(DateTime.now()),
        style: TextStyle(
            fontSize: 21, color: Palette.inMaroon, fontWeight: FontWeight.w400),
      );

  Widget _getLastUpdated(DateTime lastUpdated) =>
      Text("Last updated: ${Utils.parseLastUpdated(lastUpdated)}",
          textAlign: TextAlign.center,
          style: UIToolkit.cardTitleTextStyle,
          key: ValueKey(DateTime.now()));

  Widget _getScoreButtons(Score incrementedScore, Score decrementedScore) =>
      widget.hasAccess
          ? Column(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () =>
                        _updateHole(hole, newScore: incrementedScore)),
                IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () =>
                        _updateHole(hole, newScore: decrementedScore)),
              ],
            )
          : Container();

  Widget _getHoleButtons(IconData iconData, int value) {
    assert(value == 1 || value == -1);
    return widget.hasAccess
        ? IconButton(
            icon: Icon(iconData),
            onPressed: () {
              /// Apply value of one or minus one to the [holeNumber].
              _updateHole(hole, newHoleNumber: hole.holeNumber + value);
            },
          )
        : Padding(
            padding: EdgeInsets.only(top: 50.0),
          );
  }

  @override
  void initState() {
    super.initState();

    hole = widget.entry.holes[widget.index];
    bool isHome = widget.entry.location.isHome;

    _homeScore = _getScoreText(isHome, hole.holeScore, hole.holeScore);
    _awayScore = _getScoreText(!isHome, hole.holeScore, hole.holeScore);
    _lastUpdated = _getLastUpdated(hole.lastUpdated);
  }

  @override
  Widget build(BuildContext context) {
    bool isHome = widget.entry.location.isHome;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Strings.specificHole,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        actions: <Widget>[
          widget.hasAccess
              ? IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  tooltip: Strings.deleteHole,
                  onPressed: _deleteHole)
              : UIToolkit.getHomeButton(context),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(5.0),
          child:
              UIToolkit.getCard(ListView(shrinkWrap: true, children: <Widget>[
            widget.hasAccess
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
              _getScoreButtons(hole.holeScore.updateScore(isHome, 1),
                  hole.holeScore.updateScore(isHome, -1)),

              _getScore(_homeScore),

              Text(
                " - ",
                style: UIToolkit.leadingChildTextStyle,
              ),

              _getScore(_awayScore),

              /// Edit the away team score.

              /// If add one or remove one from the away team score!
              _getScoreButtons(hole.holeScore.updateScore(!isHome, 1),
                  hole.holeScore.updateScore(!isHome, -1)),
            ]),
            UIToolkit.getVersus(
                widget.entry, Utils.formatPlayers(hole.players)),

            /// Edit the hole number.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getHoleButtons(Icons.add, 1),

                /// Hole Number
                AnimatedSwitcher(
                  child: UIToolkit.getHoleNumberDecorated(hole.holeNumber),
                  duration: Duration(milliseconds: 300),
                ),

                _getHoleButtons(Icons.remove, -1),
              ],
            ),

            /// Display the [lastUpdated] formatted.
            Container(
                padding:
                    hole.comment.isEmpty ? EdgeInsets.only(bottom: 8.0) : null,
                child: AnimatedSwitcher(
                  child: _lastUpdated,
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
                      style: UIToolkit.cardTitleTextStyle,
                    ))
          ]))),
    );
  }
}
