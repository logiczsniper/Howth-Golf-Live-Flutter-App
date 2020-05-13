import 'package:flutter/material.dart';

enum _View { inner, outer }

class NestedAutoScroller {
  /// The scroll controllers of the [NestedListView].
  final ScrollController scrollController;
  final ScrollController innerScrollController;

  /// The total duration of the entire scroll.
  final Duration duration;

  /// The average height of an item in the list.
  ///
  /// Provides a rough estimate of how far to scroll per
  /// index.
  final double averageItemExtent;

  /// The minimum value that the distance must be to cause a scroll.
  ///
  /// The smaller the threshold, the distance must be greater and vice versa.
  final double threshold;

  /// The animation [Curve] which will be applied to the first scroll.
  ///
  /// In cases where two [animateTo] calls are required, [startCurve] will
  /// be applied to the first [animateTo] as it is at the start of the
  /// overall scroll to the [index].
  final Curve startCurve;

  /// The animated [Curve] which will be applied to the ending scroll.
  ///
  /// In cases where two [animateTo] calls are required, [endCurve] will
  /// be applied to the second [animatedTo] as it is at the end of the
  /// overall scroll to the [index].
  final Curve endCurve;

  /// The offset between the current scroll position (in total) and
  /// the ending position.
  double _distance;

  NestedAutoScroller({
    @required this.scrollController,
    @required this.innerScrollController,
    @required this.averageItemExtent,
    @required this.threshold,
    this.duration = const Duration(milliseconds: 800),
    this.startCurve = Curves.easeInToLinear,
    this.endCurve = Curves.linearToEaseOut,
  })  : assert(scrollController != null && innerScrollController != null),
        assert(averageItemExtent > 0),
        assert(threshold > 0),
        assert(duration > Duration.zero);

  @protected
  double get _currentOuterOffset => scrollController.offset ?? 0.0;

  @protected
  double get _currentInnerOffset => innerScrollController.offset ?? 0.0;

  @protected
  double get _currentTotalOffset => _currentOuterOffset + _currentInnerOffset + _itemExtent;

  @protected
  double get _totalDuration => duration.inMilliseconds.roundToDouble();

  @protected
  double get _itemExtent => averageItemExtent;

  @protected
  double get _threshold => threshold;

  @protected
  double get _minimumInnerOffset => innerScrollController.position.minScrollExtent;

  @protected
  double get _maximumOuterOffset => scrollController.position.maxScrollExtent;

  @protected
  double get distance => _distance ?? 0.0;

  @protected
  set distance(double newDistance) => _distance = newDistance;

  /// This will throw an error when the duration for the secondary scroll
  /// is zero.
  ///
  /// We ignore this error.
  @protected
  Future<void> onZeroDuration(_) => Future<void>.value();

  /// Scroll a single scroll view (either the inner or the outer).
  @protected
  void singleScroll(_View scrollView) {
    ScrollController _controller;
    double _newOffset;

    switch (scrollView) {
      case _View.inner:
        _newOffset = _currentInnerOffset - distance;
        _controller = innerScrollController;

        break;
      case _View.outer:
        _newOffset = _currentOuterOffset - distance;
        _controller = scrollController;

        break;
    }

    _controller.animateTo(
      _newOffset,
      duration: duration,
      curve: endCurve,
    );
  }

  /// Scrolls both the [scrollController] and the [innerScrollController]
  @protected
  void doubleScroll(_View startScrollView) {
    ScrollController _startController;
    ScrollController _endController;

    double _newStartOffset;
    double _newEndOffset;
    double _startDuration;
    double _endDuration;

    switch (startScrollView) {
      case _View.inner:
        _startController = innerScrollController;
        _endController = scrollController;
        _newStartOffset = _currentInnerOffset - distance;

        if (_newStartOffset < _minimumInnerOffset) {
          _newEndOffset = _currentOuterOffset + _newStartOffset;
          _newStartOffset = _minimumInnerOffset;
        }

        double _innerDistance = (_newStartOffset - _currentInnerOffset);
        double _outerDistance = (_newEndOffset ?? _currentOuterOffset) - _currentOuterOffset;
        _endDuration = (_outerDistance / distance).abs() * _totalDuration;
        _startDuration = (_innerDistance / distance).abs() * _totalDuration;

        break;
      case _View.outer:
        _startController = scrollController;
        _endController = innerScrollController;

        _newStartOffset = _currentOuterOffset - distance;

        if (_newStartOffset > _maximumOuterOffset) {
          _newEndOffset = _newStartOffset - _maximumOuterOffset;
          _newStartOffset = _maximumOuterOffset;
        }

        double _outerDistance = _newStartOffset - _currentOuterOffset;
        double _innerDistance = (_newEndOffset ?? _currentInnerOffset) - _currentInnerOffset;
        _startDuration = (_outerDistance / distance).abs() * _totalDuration;
        _endDuration = (_innerDistance / distance).abs() * _totalDuration;

        break;
    }

    _startController
        .animateTo(
          _newStartOffset,
          duration: Duration(milliseconds: _startDuration.round()),
          curve: startCurve,
        )
        .whenComplete(() => _endController
            .animateTo(
              _newEndOffset ?? _endController.offset,
              duration: Duration(milliseconds: _endDuration.round()),
              curve: endCurve,
            )
            .catchError(onZeroDuration));
  }

  /// Animated to the given [_index] in the nested scroll view.
  void animateTo(int _index) {
    assert(_index >= 0);

    /// The total distance that will be traveled.
    ///
    /// This can be a negative number; if it is, this indicates a downward
    /// scroll and vice versa.
    this.distance = _currentTotalOffset - (_itemExtent * _index);

    /// Some boolean values which make the following conditional much more
    /// clear.
    bool _isScrollUp = distance >= 0;
    bool _shouldScroll = distance.abs() > _threshold;

    /// The scroll view which the animation is starting in.
    bool _isInInner = _currentInnerOffset > _minimumInnerOffset;
    _View _startView = _isInInner ? _View.inner : _View.outer;

    if (_shouldScroll) {
      /// If one of the following is true, complete a [singleScroll]:
      ///   1) The list is currently in the inner scroll view and the request is to scroll down.
      ///   2) The list is currently in the outer scroll view and the request is to scroll up.
      /// Else, complete a [doubleScroll].
      if (_startView == _View.inner && !_isScrollUp || _startView == _View.outer && _isScrollUp) {
        singleScroll(_startView);
      } else {
        doubleScroll(_startView);
      }
    }
  }
}
