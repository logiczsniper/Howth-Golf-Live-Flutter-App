import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class TitleCrossFade extends StatelessWidget {
  final bool _toggleTitle;
  final bool password;
  final String title;
  final String hintText;
  final TextEditingController _filter;
  final TextInputType textInputType;
  final IconData iconData;

  TitleCrossFade(this._filter, this._toggleTitle,
      {this.title,
      this.hintText,
      this.iconData,
      this.textInputType,
      this.password});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
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
          child: Text(title,
              style: TextStyle(
                color: Constants.primaryAppColorDark,
              ))),
      secondChild: TextField(
        keyboardType: textInputType,
        obscureText: password,
        cursorColor: Constants.accentAppColor,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        controller: _filter,
        style: TextStyle(color: Constants.primaryAppColorDark),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(1.5),
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            prefixIcon: Icon(iconData, color: Constants.primaryAppColorDark),
            hintText: hintText,
            hintStyle: Constants.appTheme.textTheme.subhead),
      ),
    );
  }
}
