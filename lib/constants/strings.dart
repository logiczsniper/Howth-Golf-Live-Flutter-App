class Strings {
  static const String appName = "Howth Golf Live";
  static const String tapMe = "Tap anywhere to begin!";

  /// App page texts. Also used for fetching data from firestore and app routing.
  static const String currentText = "Current";
  static const String archivedText = "Archived";
  static const String competitionsText = "Competitions";
  static const String helpText = "App Help";

  /// Paths to graphics used in the app.
  static const String iconPath = "lib/assets/icon.png";

  /// Path to the JSON file storing help data.
  static const String helpDataPath = "lib/assets/help_data.json";

  static const String error =
      "Oof, please email the address in App Help to report this error.";

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
}
