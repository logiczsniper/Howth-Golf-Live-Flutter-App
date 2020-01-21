import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/database_entry.dart';
import 'package:howth_golf_live/static/fields.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/input_fields/datetime.dart';
import 'package:howth_golf_live/widgets/input_fields/text.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class CreateCompetition extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  CreateCompetition(this.snapshot);

  @override
  CreateCompetitionState createState() => CreateCompetitionState();
}

class CreateCompetitionState extends State<CreateCompetition> {
  final _formKey = GlobalKey<FormState>();
  DecoratedTextField titleField = DecoratedTextField(Fields.title);
  DecoratedTextField locationField = DecoratedTextField(Fields.location);
  DecoratedTextField oppositionField = DecoratedTextField(Fields.opposition);
  DecoratedDateTimeField dateTimeField =
      DecoratedDateTimeField("${Fields.date} & ${Fields.time}");
  Spacer spacer = Spacer(
    flex: 1,
  );
  Spacer spacerLarge = Spacer(
    flex: 4,
  );

  /// Generate the next 6-digit ID.
  int get _id {
    String code = '';
    final Random randomIntGenerator = Random();

    for (var i = 0; i < 6; i++) {
      int nextInt = randomIntGenerator.nextInt(10);
      if (nextInt == 0 && code == '') {
        i -= 1;
        continue;
      }
      code += nextInt.toString();
    }
    return int.parse(code);
  }

  Form get _form => Form(
      key: _formKey,
      child: Padding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              titleField,
              spacer,
              locationField,
              spacer,
              oppositionField,
              spacer,
              dateTimeField,
              spacerLarge
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0)));

  String get _date => dateTimeField.controller.value.text.split(" ")[0];
  String get _time => dateTimeField.controller.value.text.split(" ")[1];

  void _addCompetition() {
    /// If the form inputs have been validated, add to competitions.
    if (_formKey.currentState.validate()) {
      DataBaseEntry newEntry = DataBaseEntry(
          id: _id,
          title: titleField.controller.value.text,
          location: locationField.controller.value.text,
          opposition: oppositionField.controller.value.text,
          holes: [],
          score: Score.fresh,
          date: _date,
          time: _time);

      DocumentSnapshot documentSnapshot =
          widget.snapshot.data.documents.elementAt(0);
      var dataBaseEntries = List<dynamic>.from(documentSnapshot.data['data']);
      dataBaseEntries.add(newEntry.toJson);
      Map<String, dynamic> newData = {'data': dataBaseEntries};
      documentSnapshot.reference.updateData(newData);

      Toolkit.navigateTo(context, Toolkit.competitionsText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Competition',
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
            onPressed: _addCompetition,
            color: Palette.dark,
          )
        ],
        elevation: 0.0,
      ),
      body: _form,
      backgroundColor: Palette.light,
    );
  }
}
