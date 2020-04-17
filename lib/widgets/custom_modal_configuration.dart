import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// See
///   * [animations/lib/utils/curves.dart]
const Curve standardEasing = Cubic(0.4, 0.0, 0.2, 1);
const Curve accelerateEasing = Cubic(0.4, 0.0, 1.0, 1.0);
const Curve decelerateEasing = Cubic(0.0, 0.0, 0.2, 1.0);

// A tween that starts from 1.0 and ends at 0.0.
final Tween<double> _flippedTween = Tween<double>(
  begin: 1.0,
  end: 0.0,
);

/// See
///   * [animations/lib/shared_axis_transition.dart]
class FlippedCurveTween extends CurveTween {
  /// Creates a vertically flipped [CurveTween].
  FlippedCurveTween({
    @required Curve curve,
  })  : assert(curve != null),
        super(curve: curve);

  @override
  double transform(double t) => 1.0 - super.transform(t);
}

/// Flips the incoming passed in [Animation] to start from 1.0 and end at 0.0.
Animation<double> flipTween(Animation<double> animation) {
  return _flippedTween.animate(animation);
}

/// A custom [ModalConfiguration] which uses [MySharedAxisTransition].
///
/// See
///   * [ModalConfiguration]
///   * [FadeScaleModalConfiguration]
class CustomTransitionConfiguration extends ModalConfiguration {
  CustomTransitionConfiguration({
    Color barrierColor = Colors.black54,
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 900),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    String barrierLabel = 'Dismiss',
  }) : super(
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
        );

  @override
  Widget transitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return MySharedAxisTransition(
      transitionType: SharedAxisTransitionType.vertical,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

/// A custom transition built off of [SharedAxisTransition]
/// which is simpler as it only accounts for my specific use case as
/// well as it works for usage on [showModal] as a [ModalConfiguration].
///
/// See
///   * [CustomTransitionConfiguration]
///   * [SharedAxisTransition]
class MySharedAxisTransition extends StatefulWidget {
  /// Creates a [MySharedAxisTransition].
  ///
  /// The [animation] and [secondaryAnimation] argument are required and must
  /// not be null.
  const MySharedAxisTransition({
    Key key,
    @required this.animation,
    @required this.secondaryAnimation,
    @required this.transitionType,
    this.child,
  })  : assert(transitionType != null),
        super(key: key);

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final SharedAxisTransitionType transitionType;
  final Widget child;

  @override
  _MySharedAxisTransitionState createState() => _MySharedAxisTransitionState();
}

class _MySharedAxisTransitionState extends State<MySharedAxisTransition> {
  AnimationStatus _effectiveAnimationStatus;
  AnimationStatus _effectiveSecondaryAnimationStatus;

  @override
  void initState() {
    super.initState();
    _effectiveAnimationStatus = widget.animation.status;
    _effectiveSecondaryAnimationStatus = widget.secondaryAnimation.status;
    widget.animation.addStatusListener(_animationListener);
    widget.secondaryAnimation.addStatusListener(_secondaryAnimationListener);
  }

  void _animationListener(AnimationStatus animationStatus) {
    _effectiveAnimationStatus = _calculateEffectiveAnimationStatus(
      lastEffective: _effectiveAnimationStatus,
      current: animationStatus,
    );
  }

  void _secondaryAnimationListener(AnimationStatus animationStatus) {
    _effectiveSecondaryAnimationStatus = _calculateEffectiveAnimationStatus(
      lastEffective: _effectiveSecondaryAnimationStatus,
      current: animationStatus,
    );
  }

  AnimationStatus _calculateEffectiveAnimationStatus({
    @required AnimationStatus lastEffective,
    @required AnimationStatus current,
  }) {
    assert(current != null);
    assert(lastEffective != null);
    switch (current) {
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        return current;
      case AnimationStatus.forward:
        switch (lastEffective) {
          case AnimationStatus.dismissed:
          case AnimationStatus.completed:
          case AnimationStatus.forward:
            return current;
          case AnimationStatus.reverse:
            return lastEffective;
        }
        break;
      case AnimationStatus.reverse:
        switch (lastEffective) {
          case AnimationStatus.dismissed:
          case AnimationStatus.completed:
          case AnimationStatus.reverse:
            return current;
          case AnimationStatus.forward:
            return lastEffective;
        }
        break;
    }
    return null; // unreachable
  }

  @override
  void didUpdateWidget(MySharedAxisTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animation != widget.animation) {
      oldWidget.animation.removeStatusListener(_animationListener);
      widget.animation.addStatusListener(_animationListener);
      _animationListener(widget.animation.status);
    }

    if (oldWidget.secondaryAnimation != widget.secondaryAnimation) {
      oldWidget.secondaryAnimation
          .removeStatusListener(_secondaryAnimationListener);
      widget.secondaryAnimation.addStatusListener(_secondaryAnimationListener);
      _secondaryAnimationListener(widget.secondaryAnimation.status);
    }
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_animationListener);
    widget.secondaryAnimation.removeStatusListener(_secondaryAnimationListener);
    super.dispose();
  }

  static final Tween<double> _flippedTween = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );
  static Animation<double> _flip(Animation<double> animation) {
    return _flippedTween.animate(animation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (BuildContext context, Widget child) {
        assert(_effectiveAnimationStatus != null);
        switch (_effectiveAnimationStatus) {
          case AnimationStatus.forward:
            return _EnterTransition(
              animation: widget.animation,
              transitionType: widget.transitionType,
              child: child,
            );
          case AnimationStatus.dismissed:
          case AnimationStatus.reverse:
          case AnimationStatus.completed:
            return _ExitTransition(
              animation: _flip(widget.animation),
              transitionType: widget.transitionType,
              reverse: true,
              child: child,
            );
        }
        return null; // unreachable
      },
      child: widget.child,
    );
  }
}

class _EnterTransition extends StatelessWidget {
  const _EnterTransition({
    this.animation,
    this.transitionType,
    this.reverse = false,
    this.child,
  });

  final Animation<double> animation;
  final SharedAxisTransitionType transitionType;
  final Widget child;
  final bool reverse;

  static final Animatable<double> _fadeInTransition = CurveTween(
    curve: decelerateEasing,
  ).chain(CurveTween(curve: const Interval(0.3, 1.0)));

  @override
  Widget build(BuildContext context) {
    final Animatable<Offset> slideInTransition = Tween<Offset>(
      begin: Offset(0.0, !reverse ? 30.0 : -30.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: standardEasing));

    return FadeTransition(
      opacity: _fadeInTransition.animate(animation),
      child: Transform.translate(
        offset: slideInTransition.evaluate(animation),
        child: child,
      ),
    );
  }
}

class _ExitTransition extends StatelessWidget {
  const _ExitTransition({
    this.animation,
    this.transitionType,
    this.reverse = false,
    this.child,
  });

  final Animation<double> animation;
  final SharedAxisTransitionType transitionType;
  final Widget child;
  final bool reverse;

  static final Animatable<double> _fadeOutTransition = FlippedCurveTween(
    curve: accelerateEasing,
  ).chain(CurveTween(curve: const Interval(0.0, 0.3)));

  @override
  Widget build(BuildContext context) {
    final Animatable<Offset> slideOutTransition = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, !reverse ? -30.0 : 30.0),
    ).chain(CurveTween(curve: standardEasing));

    return FadeTransition(
      opacity: _fadeOutTransition.animate(animation),
      child: Transform.translate(
        offset: slideOutTransition.evaluate(animation),
        child: child,
      ),
    );
  }
}
