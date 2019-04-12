import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class MyCrossFade with AppResources {
  final bool _toggleTitle;
  final String title;

  MyCrossFade(this.title, [this._toggleTitle = true]);

  Widget build(BuildContext context) {
    final TextEditingController _filter = new TextEditingController();
    OutlineInputBorder outlineInputBorder = new OutlineInputBorder(
      borderSide: BorderSide(color: appTheme.accentColor, width: 1.8),
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
      duration: Duration(milliseconds: 1020),
      firstChild: Center(
          child: Column(
        children: <Widget>[
          Text(title,
              style: TextStyle(
                color: appTheme.primaryColorDark,
              ))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )),
      secondChild: new TextField(
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        controller: _filter,
        style: TextStyle(color: appTheme.primaryColorDark),
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(1.5),
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            prefixIcon:
                new Icon(Icons.search, color: appTheme.primaryColorDark),
            hintText: 'Search...',
            hintStyle: appTheme.textTheme.subhead),
      ),
    );
  }
}
