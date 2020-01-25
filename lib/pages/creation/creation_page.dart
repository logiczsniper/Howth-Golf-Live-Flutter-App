import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class CreationPage {
  /// A common spacer used among the competition creation
  /// pages.
  static final Spacer spacer = Spacer(
    flex: 1,
  );

  /// Builds a page with a suitable [AppBar] and style.
  static Scaffold construct(
      String title, void Function() onPressed, Form form) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
      body: Padding(child: Toolkit.getCard(form), padding: EdgeInsets.all(5.0)),
      backgroundColor: Palette.light,
    );
  }
}
