import 'package:flutter/foundation.dart';

class HoleViewModel extends ChangeNotifier {
  /// Only the tile at the [_openIndex] will be built
  /// already opened!
  Map<int, List<int>> _openIndices = {};

  /// The [id] of a competition mapped with the [offset] which that hole
  /// list has been scrolled to.
  Map<int, double> _offsets = {};
  Map<int, double> _innerOffsets = {};

  /// If [openIndex] is null, none have been opened!
  List<int> openIndices({@required int id}) => _openIndices[id] ?? [];

  /// Get the offset of the competition page at the given [id].
  double offset({@required int id}) => _offsets[id] ?? 0.0;

  /// Get the offset of the competition page inner scroll view at the given [id].
  double innerOffset({@required int id}) => _innerOffsets[id] ?? 0.0;

  /// Open a new index!
  void open(int id, int index) {
    /// When opening there is a threat of the
    /// id not existing in the map yet. This is never
    /// the case on [close] as when that same hole was opened,
    /// its entry was created in the [_openIndices].
    if (_openIndices.containsKey(id))
      _openIndices[id].add(index);
    else
      _openIndices[id] = [index];
    notifyListeners();
  }

  /// Close an index!
  void close(int id, int index) {
    _openIndices[id].remove(index);
    notifyListeners();
  }

  /// Scroll in a page!
  void scroll(int id, double offset) {
    _offsets[id] = offset;
    notifyListeners();
  }

  /// Scroll the inner scroll view in a page!
  void scrollInner(int id, double offset) {
    _innerOffsets[id] = offset;
    notifyListeners();
  }
}
