import 'package:flutter/foundation.dart';

class HoleViewModel extends ChangeNotifier {
  /// Only the tile at the [_openIndex] will be built
  /// already opened!
  int _openIndex;
  double _offset;

  /// If [openIndex] is null, none have been opened!
  int get openIndex => _openIndex ?? -1;

  double get offset => _offset ?? 0;

  /// Open a new index!
  void open(int index) {
    _openIndex = index;
    notifyListeners();
  }

  /// Effectively close all tiles.
  void close() {
    _openIndex = -1;
    notifyListeners();
  }

  void scroll(double offset) {
    _offset = offset;
    notifyListeners();
  }
}
