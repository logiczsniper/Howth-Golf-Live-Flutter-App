class Strings {
  static const String appName = "Howth Golf Live";
  static const String appTitle = "Howth Golf\n Live Scoring";
  static const String homeAddress = "Howth Golf Club";
  static const String empty = "";
  static const String contactDeveloper =
      "Contact the developer:\nhowth.lczernel@gmail.com";

  static const String tapMe = "Tap anywhere to begin!";
  static const String returnHome = "Tap to return to home!";
  static const String deleteHole = "Tap to delete this hole!";
  static const String tapCode = "Tap to enter a code!";
  static const String tapHelp = "Tap for help!";
  static const String tapSearch = "Tap to search!";
  static const String tapSubmit = "Tap to submit!";
  static const String tapBack = "Tap to go back!";
  static const String tapModify = "Tap to modify!";
  static const String tapAdmin = "Tap to enter admin code!";
  static const String tapManager = "Tap to enter manager code!";

  /// App page texts. Also used for fetching data from firestore and app routing.
  static const String currentText = "Current";
  static const String archivedText = "Archived";
  static const String competitionsText = "Competitions";
  static const String helpsText = "App Help";
  static const String specificHole = "Score";
  static const String specificCompetition = "Specific Competition";
  static const String newHole = "Add Players";
  static const String newCompetition = "New Competition";
  static const String modifyHole = "Modify Hole";
  static const String modifyCompetition = "Modify Competition";

  static const String currentWelcome = "Tap for current competitions!";
  static const String archivedWelcome = "Tap for archived competitions!";

  static const String competitionTitle = "The title of the competition!";
  static const String competitionDate = "Competition date (YYYY-MM-DD)!";
  static const String competitionScore = "Competition score (home on left)!";

  static const String competitionName = "Competition name";

  static const String homeScore = "Home team's overall score!";
  static const String awayScore = "Away team's overall score!";
  static const String location = "Competition location!";
  static const String date = "Competition date!";
  static const String time = "Competition time!";
  static const String players = "Home team's player(s)!";
  static const String opposition = "Away team's player(s)!";
  static const String hole = "Tap for this match-up's details!";
  static const String currentHoleNumber = "Current hole number!";
  static const String holeHomeScore = "Home team's score!";
  static const String holeAwayScore = "Away team's score!";
  static const String homeTeam = "Home team name!";
  static const String awayTeam = "Away team name!";
  static const String holeNumber = "Hole Number:";

  /// Paths to assets used in the app.
  static const String iconPath = "lib/assets/logo.svg";
  static const String helpData = "lib/assets/help_data.json";

  /// Font names.
  static const String firaSans = "FiraSans";
  static const String cormorantGaramond = "CormorantGaramond";

  static const String consequences = "You may not see the latest data.";
  static const String lostConnection = "Lost connection with database!";
  static const String error =
      "Oof, please email the address in App Help to report this error.";

  static const String ok = "OK";
  static const String cancel = "CANCEL";
  static const String irreversibleAction = "This action is irreversible.";
  static const String doubleCheck = "Are you sure you want to delete this?";

  static const String noConnection = "No connection found!";
  static const String loading = "Loading...";
  static const String failure = "Failed!";
  static const String timedOut = "Timed out!";
  static const String connected = "Connected!";
  static const String entering = "Entering...";
  static const String noCompetitions = "No competitions found!";
  static const String noHoles = "No hole data found for ";

  static const String alreadyAdmin = "You are already an admin!";
  static const String enterCode = "Enter code here...";
  static const String enterSearch = "Enter search text here...";
  static const String incorrectCode = "Incorrect code entered!";

  static const String upUnder = "Up\\Under";
  static const String aS = "A\\S";
  static const String versus = "VS";

  static const String requiredField = "This field is required.";
  static const String note = "NOTE: ";
  static const String home = "Home";
  static const String away = "Away";
  static const String howthIs = "Howth is: ";
  static const String nameCommas = "Names separated by commas.";
  static const String optional = "This is optional.";
  static const String titleLengthNote =
      "Try to keep title length < ~30 characters.";

  static const String activeAdminText = "activeAdmin";
  static const String activeCompetitionsText = "activeCompetitions";
  static const String visitedRoutes = "visitedRoutes";
}
