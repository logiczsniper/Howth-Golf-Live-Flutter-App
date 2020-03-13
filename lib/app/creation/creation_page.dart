import 'package:flutter/material.dart';

import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CreationPage {
  Padding getSpecialInput(String text, DropdownButton dropdownButton) =>
      Padding(
          child: Container(
              child: Row(children: <Widget>[
                Padding(
                    child: Text(
                      text,
                      style: TextStyles.formStyle,
                    ),
                    padding: EdgeInsets.only(left: 16.0)),
                dropdownButton
              ]),
              decoration: UIToolkit.bottomSideBoxDecoration,
              padding: EdgeInsets.only(bottom: 2.0)),
          padding: EdgeInsets.only(bottom: 16.0));

  /// Constructs a styled [DropDownButton].
  ///
  /// The [_onChanged] parameter must be a function which takes an
  /// object of type [T].
  DropdownButton<T> dropdownButton<T>(T _value, void Function(T) _onChanged,
          List<DropdownMenuItem<T>> _items) =>
      DropdownButton<T>(
          elevation: 0,
          value: _value,
          iconEnabledColor: Palette.dark,
          iconSize: 30.0,
          style: TextStyles.formStyle,
          underline: Container(
            height: 0.0,
          ),
          onChanged: _onChanged,
          items: _items);

  /// Builds a page with a suitable [AppBar] and style.
  Scaffold construct(String title, void Function() onPressed, Form form) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(title, textAlign: TextAlign.center, maxLines: 2),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check),
                tooltip: 'Tap to submit!',
                onPressed: onPressed)
          ]),
      body: Padding(child: form, padding: EdgeInsets.all(5.0)),
    );
  }
}
