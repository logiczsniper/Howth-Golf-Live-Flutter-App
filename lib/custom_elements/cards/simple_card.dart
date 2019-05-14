import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class SimpleCard extends StatelessWidget {
  final Widget child;

  SimpleCard(this.child);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 1.85,
        margin: EdgeInsets.fromLTRB(
            10.0, 6.0, 10.0, MediaQuery.of(context).size.height * 0.25),
        child: Container(
            decoration: BoxDecoration(
                color: Constants.cardAppColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0)),
            child: child));
  }
}
