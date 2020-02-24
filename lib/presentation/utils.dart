import 'dart:math';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/domain/models.dart';

/// Required logic for Howth Golf Live to function are stored in this class,
/// with their own helper methods hidden.
class Utils {
  /// Based on the user's [_searchText], filters the competitions.
  ///
  /// Utilizes the [DataBaseEntry.toString] function to get all of the
  /// data for the entry in one string.
  static List<DataBaseEntry> filterElements(
      List<DataBaseEntry> parsedElements, String _searchText) {
    List<DataBaseEntry> filteredElements = List();
    if (_searchText.isNotEmpty) {
      parsedElements.forEach((DataBaseEntry currentEntry) {
        String entryString = currentEntry.toString().toLowerCase();
        String query = _searchText.toLowerCase();
        if (entryString.contains(query)) {
          filteredElements.add(currentEntry);
        }
      });
      return filteredElements;
    }
    return parsedElements;
  }

  /// Sorts elements into either current or archived lists.
  ///
  /// Will return a list where the element at index 0 is a list of
  /// current [DataBaseEntry]s and the element at index 1 is a list of
  /// archived [DataBaseEntry]s.
  static List<List<DataBaseEntry>> sortElements(
      List<DataBaseEntry> filteredElements) {
    /// All entries are classified as current or archived.
    /// If the [competitionDate] is greater than 9 days in the past,
    /// it is archived. Otherwise, it is current.
    List<DataBaseEntry> currentElements = [];
    List<DataBaseEntry> archivedElements = [];
    for (DataBaseEntry filteredElement in filteredElements) {
      DateTime competitionDate =
          DateTime.parse("${filteredElement.date} ${filteredElement.time}");
      int daysFromNow = competitionDate.difference(DateTime.now()).inDays.abs();

      bool inPast = competitionDate.isBefore(DateTime.now());
      if (daysFromNow >= 8 && inPast) {
        archivedElements.add(filteredElement);
      } else {
        currentElements.add(filteredElement);
      }
    }
    return [currentElements, archivedElements];
  }

  /// Display extra entries depending on their access level.
  ///
  /// A default user sees entries 1-3. Team managers will
  /// see entries 1-4 and admins will see all 5 app help entries.
  static int bonusEntries(List<String> competitionAccess, bool isAdmin) {
    if (isAdmin)
      return 2;
    else if (competitionAccess.isNotEmpty)
      return 1;
    else
      return 0;
  }

  /// Generates a 6 digit id using [Random].
  ///
  /// Appends each new value to a string before parsing the
  /// final value. Does not allow 0 to be the first value in the
  /// [code] as when this is parsed, the 0 will be lost.
  static int get id {
    String code = '';
    final Random randomIntGenerator = Random();

    for (int i = 0; i < 6; i++) {
      int nextInt = randomIntGenerator.nextInt(10);
      if (nextInt == 0 && code == '') {
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
        ? ""
        : double.tryParse(score).toInt().toString();
  }

  /// Turn a list of players, [playerList], into one string with
  /// those individual player names separated by commas, apart from the last
  /// player in the list.
  static String formatPlayers(List<String> playerList) {
    String output = "";
    bool isLastPlayer = false;
    for (String player in playerList) {
      output += player.toString();
      isLastPlayer = playerList.indexOf(player) == playerList.length - 1;
      if (!isLastPlayer) {
        output += ", ";
      }
    }
    return output;
  }

  /// Modifies the field to a nicer looking string.
  ///
  /// Does this by capitalising each term and replaces "_" with " ".
  static String formatHintText(String input) {
    input = input.replaceAll("_", " ");

    String caps = "";

    for (String word in input.split(" ")) {
      caps += word[0].toUpperCase() + word.substring(1) + " ";
    }

    return caps.trim();
  }

  /// Require some form of input.
  static String validator(dynamic input, bool isRequired) {
    if (input == null || input == "" && isRequired)
      return Strings.requiredField;
    else
      return null;
  }

  /// Convert [lastUpdated] to a pretty string.
  static String parseLastUpdated(DateTime lastUpdated) {
    Duration difference = DateTime.now().difference(lastUpdated);

    if (difference.inHours < 1)

      /// Less than an hour; return in minutes.
      return "${difference.inMinutes} minute(s) ago";
    else if (difference.inDays < 1)

      /// Less than a day; return in hours.
      return "${difference.inHours} hour(s) ago";
    else if (difference.inDays < 365)

      /// Less than a year; return in days.
      return "${difference.inDays} day(s) ago";
    else

      /// Greater than a year; return in years.
      return "${(difference.inDays ~/ 365)} year(s) ago";
  }
}
