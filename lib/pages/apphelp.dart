import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/parents/simple_page.dart';
import 'package:howth_golf_live/static/constants.dart';

class AppHelpPage extends SimplePage {
  static List<Widget> buildBody(ScrollController _controller) {
    final TextEditingController _filter = new TextEditingController();
    OutlineInputBorder outlineInputBorder = new OutlineInputBorder(
      borderSide: BorderSide(color: Constants.accentAppColor, width: 1.8),
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
    );

    return <Widget>[
      RichText(
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          maxLines: 20,
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text:
                    "Looking for help? \nPlease email the developer (address below) if you have any queries regarding the usage of the app, if you would like to report a bug (if so please provide as much detail as possible) or any other related issue:\n\n",
                style: TextStyle(
                    color: Constants.primaryAppColorDark, fontSize: 17)),
            TextSpan(
                text: "howth.lczernel@gmail.com\n\n",
                style:
                    TextStyle(color: Constants.accentAppColor, fontSize: 17)),
            TextSpan(
                text:
                    "If you have an access code you would like to use, enter the code provided to you by an admin member of Howth Golf Club in the box below. When the code is in, click the arrow icon in the box to submit your code.\n",
                style: TextStyle(
                    color: Constants.primaryAppColorDark, fontSize: 17))
          ])),
      Padding(
        padding: EdgeInsets.only(bottom: 3.0),
      ),
      TextField(
        cursorColor: Constants.accentAppColor,
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        controller: _filter,
        onTap: () {
          print("YOOO");
          _controller.animateTo(0,
              duration: Duration(seconds: 2), curve: Curves.easeInOut);
        },
        style: TextStyle(color: Constants.primaryAppColorDark),
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(1.5),
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            prefixIcon: new IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  var text = _filter.text;
                  print(text);
                },
                color: Constants.primaryAppColorDark),
            hintText: 'Enter your access code',
            hintStyle: Constants.appTheme.textTheme.subhead),
      )
    ];
  }

  AppHelpPage({Key key}) : super(buildBody, Constants.appHelpText, key: key);
}
