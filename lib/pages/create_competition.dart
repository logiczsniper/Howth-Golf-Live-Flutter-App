import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:howth_golf_live/custom_elements/form_field.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class CreateCompetition extends StatefulWidget {
  @override
  CreateCompetitionState createState() => CreateCompetitionState();
}

class CreateCompetitionState extends State<CreateCompetition> {
  static String _capitalize(String input) =>
      input[0].toUpperCase() + input.substring(1);

  /// Generate the next 6-digit ID.
  ///
  /// Uses [Uuid] to generate a long random id. While the output
  /// id is less than 7 characters, it will continue to add the numeric
  /// characters from the [v4] uuid to the output id. Returns [null]
  /// in the case that the id could not be parsed at the end.
  static int _generateId() {
    var uuid = Uuid();
    var fullId = uuid.v4();
    List idCharacters = fullId.toString().split('');
    String id = '';
    for (String character in idCharacters) {
      if (id.length < 7 && character is int) {
        id += character.toString();
      }
    }
    return int.tryParse(id);
  }

  Form formBuilder() {
    DecoratedTextField titleField =
        DecoratedTextField(_capitalize(Toolkit.title));
    DecoratedTextField locationField =
        DecoratedTextField(_capitalize(Toolkit.location));
    DecoratedTextField oppositionField =
        DecoratedTextField(_capitalize(Toolkit.opposition));
    DecoratedDateTimeField dateField = DecoratedDateTimeField(
        "${_capitalize(Toolkit.date)} & ${_capitalize(Toolkit.time)}");

    return Form(
        child: Padding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [titleField, locationField, oppositionField, dateField],
            ),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: create app bar which makes sense- home button not needed.
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Competition',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: Toolkit.primaryAppColorDark,
            )),
        backgroundColor: Toolkit.primaryAppColor,
        iconTheme: IconThemeData(color: Toolkit.primaryAppColorDark),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            tooltip: 'Tap to return to home!',
            onPressed: () =>
                Toolkit.navigateTo(context, Toolkit.competitionsText),
            color: Toolkit.primaryAppColorDark,
          )
        ],
        elevation: 0.0,
      ),
      body: formBuilder(),
      backgroundColor: Toolkit.primaryAppColor,
    );
  }
}
