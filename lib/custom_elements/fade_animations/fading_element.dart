import 'package:flutter/material.dart';

class FadingElement extends StatefulWidget {
  final Widget target;
  final bool flashing;
  final bool fadeIn;
  final Duration duration;

  FadingElement(this.target, this.flashing,
      {this.fadeIn: true, this.duration: const Duration(milliseconds: 800)});

  _FadingElementState createState() => new _FadingElementState(this.target);
}

class _FadingElementState extends State<FadingElement>
    with TickerProviderStateMixin {
  AnimationController _opacityController;
  Animation<double> _opacity;
  Widget target;

  _FadingElementState(this.target);

  @override
  void initState() {
    super.initState();
    double finalOpacity = this.widget.fadeIn ? 1.0 : 0.1;
    _opacityController =
        new AnimationController(vsync: this, duration: this.widget.duration);
    _opacity =
        new CurvedAnimation(parent: _opacityController, curve: Curves.easeInOut)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _opacityController.reverse();
            } else if (status == AnimationStatus.dismissed &&
                this.widget.flashing) {
              _opacityController.forward();
            } else if (finalOpacity == _opacityController.value &&
                !this.widget.flashing) {
              _opacityController.stop(canceled: true);
            }
          });
    _opacityController.forward();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
      opacity: _opacity,
      child: target,
    );
  }
}
