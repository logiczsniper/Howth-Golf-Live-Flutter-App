import 'package:howth_golf_live/static/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: is class redundant???
class UserValidity {
  SharedPreferences sharedPreferences;

  // TODO: if this method is only used inside this class, HIDE IT!
  updatePreferences() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  bool isAdmin() {
    return updatePreferences().getBool(Constants.activeAdminText);
  }

  String competitionAccess() {
    return updatePreferences().getString(Constants.activeCompetitionText);
  }
}
