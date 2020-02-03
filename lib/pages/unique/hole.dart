import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/palette.dart';

class HolePage extends StatefulWidget {
  final String title;
  final DataBaseEntry entry;

  HolePage(this.title, this.entry);

  @override
  HolePageState createState() => HolePageState();
}

class HolePageState extends State<HolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          backgroundColor: Palette.light,
          iconTheme: IconThemeData(color: Palette.dark),
          elevation: 0.0,
        ),
        body: Text("Hole page for ${widget.entry.id}"),
        backgroundColor: Palette.light);
  }
}
