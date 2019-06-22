import 'package:howth_golf_live/static/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserValidity {
  SharedPreferences sharedPreferences;

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
