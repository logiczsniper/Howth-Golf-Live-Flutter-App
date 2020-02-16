import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// When getting data from preferences, it is vital that these values are used as keys.
const String _activeAdminText = "activeAdmin";
const String _activeCompetitionsText = "activeCompetitions";

class Privileges {
  final bool isAdmin;
  final List<String> competitionAccess;

  static void clearPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  static Future<SharedPreferences> get _preferences =>
      SharedPreferences.getInstance();

  static Future<bool> adminAttempt(
      String codeAttempt, int id, Function(Future<bool>) _onComplete) {
    /// Fetch the admin code from the database.
    Future<bool> result =
        Future<bool>.value(Toolkit.stream.first.then((QuerySnapshot snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.documents.elementAt(0);
      int adminCode = documentSnapshot.data['admin_code'];

      if (codeAttempt == adminCode.toString()) {
        _preferences.then((SharedPreferences preferences) {
          preferences.setBool(_activeAdminText, true);
        });

        return true;
      }
      return false;
    }));

    _onComplete(result);
    return result;
  }

  static Future<bool> managerAttempt(
      String codeAttempt, int id, Function(Future<bool>) _onComplete) {
    String correctCode = id.toString();
    Future<bool> result;

    if (codeAttempt == correctCode) {
      _preferences.then((SharedPreferences preferences) {
        /// Get current competitions that the user has access to.
        List<String> competitionsAccessed =
            preferences.getStringList(_activeCompetitionsText) ?? [];

        /// Append this competition.
        competitionsAccessed.add(id.toString());

        /// Write this to [SharedPreferences].
        preferences.setStringList(
            _activeCompetitionsText, competitionsAccessed);
      });

      result = Future.value(true);
    } else {
      result = Future.value(false);
    }

    _onComplete(result);
    return result;
  }

  /// Converting preferences into [Privileges] object.
  Privileges.fromPreferences(SharedPreferences preferences)
      : isAdmin = preferences.getBool(_activeAdminText),
        competitionAccess = preferences.getStringList(_activeCompetitionsText);

  Privileges({this.isAdmin, this.competitionAccess});
}
