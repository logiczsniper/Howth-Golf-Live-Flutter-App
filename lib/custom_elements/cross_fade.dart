import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class MyCrossFade {
  final bool _toggleTitle;
  final String title;
  final TextEditingController _filter;

  MyCrossFade(this.title, this._filter, [this._toggleTitle = true]);

  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = new OutlineInputBorder(
      borderSide: BorderSide(color: Constants.accentAppColor, width: 1.8),
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
    );

    return AnimatedCrossFade(
      sizeCurve: Curves.easeOutCirc,
      firstCurve: Curves.easeInOutExpo,
      secondCurve: Curves.easeInOutExpo,
      crossFadeState:
          _toggleTitle ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 1010),
      firstChild: Center(
          child: Column(
        children: <Widget>[
          Text(title,
              style: TextStyle(
                color: Constants.primaryAppColorDark,
              ))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )),
      secondChild: new TextField(
        cursorColor: Constants.accentAppColor,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        controller: _filter,
        style: TextStyle(color: Constants.primaryAppColorDark),
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(1.5),
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            prefixIcon:
                new Icon(Icons.search, color: Constants.primaryAppColorDark),
            hintText: 'Search...',
            hintStyle: Constants.appTheme.textTheme.subhead),
      ),
    );
  }
}
