import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/form_field.dart';
import 'package:howth_golf_live/static/toolkit.dart';

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
