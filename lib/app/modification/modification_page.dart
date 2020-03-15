import 'package:flutter/material.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class ModificationPage {
  /// Builds a page with a suitable [AppBar] and style.
  Scaffold construct(String title, void Function() onPressed, Form form) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(title, textAlign: TextAlign.center, maxLines: 2),
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