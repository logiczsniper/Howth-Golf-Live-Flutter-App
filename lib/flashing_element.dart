import 'package:flutter/material.dart';

class FlashingElement extends StatefulWidget {
  final Widget target;
  FlashingElement(this.target);

  FlashingElementState createState() => new FlashingElementState(this.target);
}

class FlashingElementState extends State<FlashingElement>
    with TickerProviderStateMixin {
  AnimationController _opacityController;
  Animation<double> _opacity;
  Widget target;

  FlashingElementState(this.target);

  @override
  void initState() {
    super.initState();
    _opacityController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _opacity =
        new CurvedAnimation(parent: _opacityController, curve: Curves.easeInOut)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _opacityController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _opacityController.forward();
            }
          });
    _opacityController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _opacityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(alignment: Alignment.center, children: <Widget>[
      new FadeTransition(
        opacity: _opacity,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[target],
        ),
      ),
      new Container()
    ]));
  }
}
