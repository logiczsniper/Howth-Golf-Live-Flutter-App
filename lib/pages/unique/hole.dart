import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/themes.dart';
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
  Widget _holeNumber;
  Widget _lastUpdated;

  /// Deletes the holes at the given [index] within the list of holes
  /// for this competition.
  void _deleteHole() {
    final int currentId = widget.entry.id;
    Future<QuerySnapshot> newData = DataBaseInteraction.stream.first;

    newData.then((QuerySnapshot snapshot) {
      DataBaseInteraction.deleteHole(
          context, snapshot, widget.index, currentId);
    });
  }

  /// Update the [currentHole].
  ///
  /// Can update the [holeScore], [holeNumber] or both. Also will
  /// update [lastUpdated] to now.
  void _updateHole(Hole currentHole, {Score newScore, int newHoleNumber}) {
    Hole updatedHole = Hole(
        holeNumber: newHoleNumber ?? currentHole.holeNumber,
        holeScore: newScore ?? currentHole.holeScore,
        players: currentHole.players,
        comment: currentHole.comment,
        lastUpdated: DateTime.now());

    final int currentId = widget.entry.id;
    Future<QuerySnapshot> newData = DataBaseInteraction.stream.first;

    newData.then((QuerySnapshot snapshot) {
      DataBaseInteraction.updateHole(
          context, snapshot, widget.index, currentId, updatedHole);
    });

    setState(() {
      /// Rebuild with new data.
      String howthOldScore = hole.holeScore.howth;
      String oppositionOldScore = hole.holeScore.opposition;

      bool isHome = widget.entry.location.isHome;

      hole = updatedHole;
      _homeScore = UIToolkit.scoreText(
          isHome ? hole.holeScore.howth : hole.holeScore.opposition,
          isHome ? howthOldScore : oppositionOldScore);
      _awayScore = UIToolkit.scoreText(
          !isHome ? hole.holeScore.howth : hole.holeScore.opposition,
          !isHome ? howthOldScore : oppositionOldScore);
      _holeNumber = _getHoleNumber(hole.holeNumber);
      _lastUpdated = _getLastUpdated(hole.lastUpdated);
    });
  }

  Flexible _getScore(Widget _teamScore) => Flexible(
      child: Container(
          padding: EdgeInsets.all(12.0),
          child: AnimatedSwitcher(
              child: _teamScore, duration: Duration(milliseconds: 350)),
          decoration: UIToolkit.scoreDecoration));

  Text _getHoleNumber(int holeNumber) => Text(
      holeNumber.toString().length == 1
          ? "0$holeNumber"
          : holeNumber.toString(),
      style: UIToolkit.cardSubTitleTextStyle,
      key: ValueKey(DateTime.now()));

  Widget _getLastUpdated(DateTime lastUpdated) =>
      Text("Last updated: ${Strings.parseLastUpdated(lastUpdated)}",
          textAlign: TextAlign.center,
          style: UIToolkit.cardTitleTextStyle,
          key: ValueKey(DateTime.now()));

  @override
  void initState() {
    super.initState();

    hole = widget.entry.holes[widget.index];

    String homeScore = widget.entry.location.isHome
        ? hole.holeScore.howth
        : hole.holeScore.opposition;

    String awayScore = !widget.entry.location.isHome
        ? hole.holeScore.howth
        : hole.holeScore.opposition;

    _homeScore = UIToolkit.scoreText(homeScore, homeScore);
    _awayScore = UIToolkit.scoreText(awayScore, awayScore);
    _holeNumber = _getHoleNumber(hole.holeNumber);
    _lastUpdated = _getLastUpdated(hole.lastUpdated);
  }

  @override
  Widget build(BuildContext context) {
    bool isHome = widget.entry.location.isHome;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Specific Hole",
            style: Themes.titleStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          actions: <Widget>[
            widget.hasAccess
                ? IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    tooltip: "Delete this hole!",
                    onPressed: _deleteHole)
                : UIToolkit.getHomeButton(context),
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(5.0),
            child:
                UIToolkit.getCard(ListView(shrinkWrap: true, children: <Widget>[
              widget.hasAccess
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /// Edit the home team score.
                    widget.hasAccess
                        ? Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  /// If howth [isHome], then add one to howth score as howth
                                  /// is the home team!
                                  Score updatedScore =
                                      hole.holeScore.updateScore(isHome, 1);

                                  _updateHole(hole, newScore: updatedScore);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  /// Remove one from the home team score.
                                  Score updatedScore =
                                      hole.holeScore.updateScore(isHome, -1);

                                  _updateHole(hole, newScore: updatedScore);
                                },
                              ),
                            ],
                          )
                        : Container(),

                    _getScore(_homeScore),

                    Text(
                      " - ",
                      style: UIToolkit.leadingChildTextStyle,
                    ),

                    _getScore(_awayScore),

                    /// Edit the away team score.
                    widget.hasAccess
                        ? Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  /// Add one to the away team score.
                                  Score updatedScore =
                                      hole.holeScore.updateScore(!isHome, 1);

                                  _updateHole(hole, newScore: updatedScore);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  /// Remove one from the away team score.
                                  Score updatedScore =
                                      hole.holeScore.updateScore(!isHome, -1);

                                  _updateHole(hole, newScore: updatedScore);
                                },
                              ),
                            ],
                          )
                        : Container(),
                  ]),
              UIToolkit.getVersus(
                  widget.entry, Strings.formatPlayers(hole.players)),

              /// Edit the hole number.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// TODO: extract away AddButton and RemoveButton with onPressed parameter
                  /// addButton(() => updateHole(sdfsd))
                  widget.hasAccess
                      ? IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            /// Add one to the [holeNumber].
                            _updateHole(hole,
                                newHoleNumber: hole.holeNumber + 1);
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 50.0),
                        ),

                  /// Hole Number
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 2.0),
                      padding: EdgeInsets.all(2.5),
                      child: Padding(
                          child: AnimatedSwitcher(
                            child: _holeNumber,
                            duration: Duration(milliseconds: 350),
                          ),
                          padding: EdgeInsets.all(4.0)),
                      decoration: BoxDecoration(
                          color: Palette.light,
                          border: Border.all(color: Palette.maroon, width: 1.5),
                          borderRadius: BorderRadius.circular(9.0))),

                  widget.hasAccess
                      ? IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            /// Remove one from the [holeNumber].
                            _updateHole(hole,
                                newHoleNumber: hole.holeNumber - 1);
                          },
                        )
                      : Container(),
                ],
              ),

              /// Display the [lastUpdated] formatted.
              Container(
                  padding: hole.comment.isEmpty
                      ? EdgeInsets.only(bottom: 8.0)
                      : null,
                  child: AnimatedSwitcher(
                    child: _lastUpdated,
                    duration: Duration(milliseconds: 500),
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
        backgroundColor: Palette.light);
  }
}
