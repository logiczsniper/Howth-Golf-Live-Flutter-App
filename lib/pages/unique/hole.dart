import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:howth_golf_live/widgets/competition_details/side_flexible.dart';

class HolePage extends StatefulWidget {
  final DataBaseEntry entry;
  final int index;
  final bool hasAccess;

  HolePage(this.entry, this.index, this.hasAccess);

  @override
  HolePageState createState() => HolePageState();
}

class HolePageState extends State<HolePage> {
  int howthScore;
  int oppositionScore;

  /// Deletes the holes at the given [index] within the list of holes
  /// for this competition.
  void _deleteHole() {
    final int currentId = widget.entry.id;
    Future<QuerySnapshot> newData = Toolkit.stream.first;

    newData.then((QuerySnapshot snapshot) {
      DataBaseInteraction.deleteHole(
          context, snapshot, widget.index, currentId);
    });

    Navigator.of(context).pop();
  }

  /// TODO: this method
  void _updateHole(Score newScore) {}

  @override
  void initState() {
    super.initState();

    howthScore = int.tryParse(widget.entry.holes[widget.index].holeScore.howth);
    oppositionScore =
        int.tryParse(widget.entry.holes[widget.index].holeScore.opposition);
  }

  @override
  Widget build(BuildContext context) {
    Hole hole = widget.entry.holes[widget.index];
    bool isHome = widget.entry.location.isHome;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.entry.title,
            style: Toolkit.titleTextStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          backgroundColor: Palette.light,
          iconTheme: IconThemeData(color: Palette.dark),
          actions: <Widget>[
            widget.hasAccess
                ? IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    tooltip: "Delete this hole!",
                    onPressed: _deleteHole)
                : Toolkit.getHomeButton(context),
          ],
          elevation: 0.0,
        ),
        body: Container(
            padding: EdgeInsets.all(5.0),
            child:
                Toolkit.getCard(ListView(shrinkWrap: true, children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.hasAccess
                      ? IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Palette.dark,
                          ),
                          onPressed: () {
                            print("Add one");
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 50.0),
                        ),
                  Toolkit.getHoleNumberDecorated(hole.holeNumber),
                  widget.hasAccess
                      ? IconButton(
                          icon: Icon(Icons.remove, color: Palette.dark),
                          onPressed: () {
                            print("Subtract one");
                          },
                        )
                      : Container(),
                ],
              ),
              Toolkit.getVersus(
                  widget.entry, Toolkit.formatPlayerList(hole.players)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                widget.hasAccess
                    ? Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Palette.dark,
                            ),
                            onPressed: () {
                              print("Add one");
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Palette.dark,
                            ),
                            onPressed: () {
                              print("REmove one");
                            },
                          ),
                        ],
                      )
                    : Container(),
                SideFlexible(
                    isHome ? hole.holeScore.howth : hole.holeScore.opposition),
                Text(
                  " - ",
                  style: Toolkit.leadingChildTextStyle,
                ),
                SideFlexible(
                    !isHome ? hole.holeScore.howth : hole.holeScore.opposition),
                widget.hasAccess
                    ? Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Palette.dark,
                            ),
                            onPressed: () {
                              print("Add one");
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Palette.dark,
                            ),
                            onPressed: () {
                              print("REmove one");
                            },
                          ),
                        ],
                      )
                    : Container(),
              ]),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    hole.comment.isEmpty ? "" : "Comment: ${hole.comment}",
                    textAlign: TextAlign.center,
                    style: Toolkit.cardTitleTextStyle,
                  ))
            ]))),
        backgroundColor: Palette.light);
  }
}
