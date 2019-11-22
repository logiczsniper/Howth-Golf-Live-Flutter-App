import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/form_field.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: all of this
class CreateCompetition extends StatefulWidget {
  @override
  CreateCompetitionState createState() => CreateCompetitionState();
}

class CreateCompetitionState extends State<CreateCompetition> {
  Form formBuilder() {
    DecoratedFormField titleField = DecoratedFormField('Competition Title');
    DecoratedFormField locationField = DecoratedFormField('Location');
    DecoratedFormField oppositionField = DecoratedFormField('Opposition');

    return Form(
        child: Padding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [titleField, locationField, oppositionField],
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
              color: Constants.primaryAppColorDark,
            )),
        backgroundColor: Constants.primaryAppColor,
        iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            tooltip: 'Tap to return to home!',
            onPressed: () {
              final preferences = SharedPreferences.getInstance();
              preferences.then((SharedPreferences preferences) {
                Navigator.pushNamed(context, '/' + Constants.competitionsText,
                    arguments: Privileges.buildFromPreferences(preferences));
              });
            },
            color: Constants.primaryAppColorDark,
          )
        ],
        elevation: 0.0,
      ),
      body: formBuilder(),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
