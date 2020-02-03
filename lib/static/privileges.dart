import 'package:howth_golf_live/static/toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Privileges {
  final bool isAdmin;
  final List<String> competitionAccess;

  /// Converting preferences into [Privileges] object.
  Privileges.fromPreferences(SharedPreferences preferences)
      : isAdmin = preferences.getBool(Toolkit.activeAdminText),
        competitionAccess =
            preferences.getStringList(Toolkit.activeCompetitionsText);

  Privileges({this.isAdmin, this.competitionAccess});
}
