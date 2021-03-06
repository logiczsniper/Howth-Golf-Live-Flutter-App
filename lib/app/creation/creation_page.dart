import 'package:flutter/material.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CreationPage {
  Padding getSpecialInput(String text, DropdownButton dropdownButton) =>
      Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Container(
          decoration: UIToolkit.bottomSideBoxDecoration,
          padding: EdgeInsets.only(bottom: 2.0),
          child: Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                text,
                style: TextStyles.form,
              ),
            ),
            dropdownButton
          ]),
        ),
      );

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
        style: TextStyles.form,
        onChanged: _onChanged,
        items: _items,
        underline: Container(
          height: 0.0,
        ),
      );

  /// Builds a page with a suitable [AppBar] and style.
  Scaffold construct(String title, void Function() onPressed, Form form) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(title, textAlign: TextAlign.center, maxLines: 2),
          leading: CloseButton(),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check),
                tooltip: Strings.tapSubmit,
                onPressed: onPressed)
          ]),
      body: Padding(child: form, padding: EdgeInsets.all(5.0)),
    );
  }
}
