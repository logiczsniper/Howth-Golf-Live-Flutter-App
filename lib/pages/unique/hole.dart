import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/database_interation.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:stepper_touch/stepper_touch.dart';

class HolePage extends StatefulWidget {
  final DataBaseEntry entry;
  final int index;

  HolePage(this.entry, this.index);

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

    setState(() {
      newData.then((QuerySnapshot snapshot) {
        DataBaseInteraction.deleteHole(
            context, snapshot, widget.index, currentId);
      });
    });
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
            IconButton(
                icon: Icon(Icons.remove_circle_outline),
                tooltip: "Delete this hole!",
                onPressed: _deleteHole),
          ],
          elevation: 0.0,
        ),
        body: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Hole Number: ",
                        style: Toolkit.hintTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                              text: hole.holeNumber.toString(),
                              style: Toolkit.leadingChildTextStyle)
                        ]),
                  ),
                ])),
        backgroundColor: Palette.light);
  }
}
