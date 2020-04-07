import 'package:flutter/material.dart';

class CurvedClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var _path = Path();
    _path.lineTo(0, size.height / 1.25);

    var _controlPoint1 = Offset(0, size.height);
    var _middlePoint = Offset(size.width / 2, size.height);

    var _controlPoint2 = Offset(size.width, size.height);
    var _endPoint = Offset(size.width, size.height / 1.25);

    // var _controlPoint2 = Offset(size.width - 40, size.height);
    // var _endPoint = Offset(size.width, size.height - 25);

    _path.quadraticBezierTo(
        _controlPoint1.dx, _controlPoint1.dy, _middlePoint.dx, _middlePoint.dy);
    _path.quadraticBezierTo(
        _controlPoint2.dx, _controlPoint2.dy, _endPoint.dx, _endPoint.dy);
    _path.lineTo(size.width, 0);

    return _path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
