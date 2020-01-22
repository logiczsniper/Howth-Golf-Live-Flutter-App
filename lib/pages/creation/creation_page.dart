import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';

class CreationPage {
  static Scaffold construct(
      String title, void Function() onPressed, Form form) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: Palette.dark,
            )),
        backgroundColor: Palette.light,
        iconTheme: IconThemeData(color: Palette.dark),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'Tap to submit!',
            onPressed: onPressed,
            color: Palette.dark,
          )
        ],
        elevation: 0.0,
      ),
      body: form,
      backgroundColor: Palette.light,
    );
  }
}
