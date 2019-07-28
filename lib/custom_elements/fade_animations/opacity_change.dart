import 'package:flutter/material.dart';

class OpacityChangeWidget extends StatefulWidget {
  final Widget target;
  final bool flashing;

  OpacityChangeWidget({@required this.target, this.flashing = false});
  @override
  State<StatefulWidget> createState() => new _OpacityChangeWidgetState();
}

class _OpacityChangeWidgetState extends State<OpacityChangeWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener((status) {
        if (widget.flashing && status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (widget.flashing && status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(opacity: _animation, child: widget.target);
  }
}
