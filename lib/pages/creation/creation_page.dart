import 'package:flutter/material.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CreationPage {
  static Padding getSpecialInput(String text, DropdownButton dropdownButton) =>
      Padding(
          child: Container(
            child: Row(
              children: <Widget>[
                Padding(
                    child: Text(
                      text,
                      style: Toolkit.formTextStyle,
                    ),
                    padding: EdgeInsets.only(left: 16.0)),
                dropdownButton
              ],
            ),
            decoration: Toolkit.bottomSideBoxDecoration,
            padding: EdgeInsets.only(bottom: 2.0),
          ),
          padding: EdgeInsets.only(bottom: 16.0));

  /// Builds a page with a suitable [AppBar] and style.
  static Scaffold construct(
      String title, void Function() onPressed, Form form) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Toolkit.titleTextStyle),
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
      body: Padding(child: form, padding: EdgeInsets.all(5.0)),
      backgroundColor: Palette.light,
    );
  }
}
