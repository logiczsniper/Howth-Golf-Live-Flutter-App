import 'package:flutter/material.dart';

class StyledCard extends StatelessWidget {
  final Widget child;
  final bool simple;

  StyledCard(this.child, {this.simple = false});

  @override
  Widget build(BuildContext context) {
    var margin = simple
        ? EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 300.0)
        : EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0);
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 1.85,
        margin: margin,
        child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 248, 248),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0)),
            child: child));
  }
}
