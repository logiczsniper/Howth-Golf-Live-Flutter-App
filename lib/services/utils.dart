import 'dart:math';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';

/// Required logic for Howth Golf Live to function are stored in this class,
/// with their own helper methods hidden.
class Utils {
  /// Generates a 6 digit id using [Random].
  ///
  /// Appends each new value to a string before parsing the
  /// final value. Does not allow 0 to be the first value in the
  /// [code] as when this is parsed, the 0 will be lost.
  static int get id {
    String code = Strings.empty;
    final Random randomIntGenerator = Random();

    for (int i = 0; i < 6; i++) {
      int nextInt = randomIntGenerator.nextInt(10);
      if (nextInt == 0 && code.isEmpty) {
        i -= 1;
        continue;
      }
      code += nextInt.toString();
    }
    return int.parse(code);
  }

  /// Determines whether [score] is a string containing a fraction or whole
  /// number.
  static bool isFraction(String score) =>
      double.tryParse(score) - double.tryParse(score).toInt() != 0;

  /// Returns the main number as a string from the [score].
  ///
  /// If the main number is 0, this will display just 1 / 2 rather than
  /// 0 and 1 / 2.
  static String getMainNumber(bool condition, Score scores) {
    String score = condition ? scores.howth : scores.opposition;

    return double.tryParse(score).toInt() == 0 && isFraction(score)
        ? Strings.empty
        : double.tryParse(score).toInt().toString();
  }
}
