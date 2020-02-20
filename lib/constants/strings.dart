class Strings {
  static const String appName = "Howth Golf Live";

  static const String tapMe = "Tap anywhere to begin!";
  static const String returnHome = "Tap to return to home!";

  /// App page texts. Also used for fetching data from firestore and app routing.
  static const String currentText = "Current";
  static const String archivedText = "Archived";
  static const String competitionsText = "Competitions";
  static const String helpText = "App Help";

  /// Paths to graphics used in the app.
  static const String iconPath = "lib/assets/icon.png";

  /// Font names.
  static const String firaSans = "FiraSans";
  static const String cormorantGaramond = "CormorantGaramond";

  static const String error =
      "Oof, please email the address in App Help to report this error.";
  static const String note = "NOTE: ";

  /// TODO: all of the following string methods : PR&L

  /// Determines whether [score] is a string containing a fraction or whole
  /// number.
  static bool isFraction(String score) =>
      double.tryParse(score) - double.tryParse(score).toInt() != 0;

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

  /// Returns the main number as a string from the [score].
  ///
  /// If the main number is 0, this will display just 1 / 2 rather than
  /// 0 and 1 / 2.
  static String getTextSpanText(String score) =>
      double.tryParse(score).toInt() == 0 && Strings.isFraction(score)
          ? ""
          : double.tryParse(score).toInt().toString();
}
