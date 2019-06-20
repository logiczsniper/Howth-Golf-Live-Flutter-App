import 'package:howth_golf_live/static/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserValidity {
  SharedPreferences sharedPreferences;

  void updatePreferences() async {
    final preferences = SharedPreferences.getInstance();
    preferences.then((SharedPreferences preferences) {
      sharedPreferences = preferences;
    });
  }

  bool isAdmin() {
    updatePreferences();
    return sharedPreferences.getBool(Constants.activeAdminText);
  }

  String competitionAccess() {
    updatePreferences();
    return sharedPreferences.getString(Constants.activeCompetitionText);
  }
}
