import 'package:flutter/material.dart';

class OpacityChangeWidget extends StatefulWidget {
  final Widget target;
  final bool flashing;

  OpacityChangeWidget({@required this.target, this.flashing = false});
  @override
  State<StatefulWidget> createState() => _OpacityChangeWidgetState();
}

class _OpacityChangeWidgetState extends State<OpacityChangeWidget>
    with SingleTickerProviderStateMixin {
  /// Causes the widget to flash or finish.
  ///
  /// If [widget.flashing] is True, then the animation is reversed. Else,
  /// it is let finish.
  void _statusListener(AnimationStatus status) {
    if (widget.flashing) {
      switch (status) {
        case AnimationStatus.completed:
          _controller.reverse();
          break;
        case AnimationStatus.dismissed:
          _controller.forward();
          break;
        default:
          break;
      }
    }
  }

  AnimationController _controller;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    /// If [widget.flashing], the duration should be longer and slower versus
    /// else, the duration should be quick and snappy.
    int duration = widget.flashing ? 1000 : 600;
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener(_statusListener);
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
