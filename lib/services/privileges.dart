import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howth_golf_live/static/toolkit.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// When getting data from preferences, it is vital that these values are used as keys.
const String _activeAdminText = "activeAdmin";
const String _activeCompetitionsText = "activeCompetitions";

class Privileges {
  final bool isAdmin;
  final List<String> competitionAccess;

  /// Removes all locally stored data, resetting the users privileges.
  static void clearPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  /// Get the instance of [SharedPreferences].
  static Future<SharedPreferences> get _preferences =>
      SharedPreferences.getInstance();

  /// Make an attempt to become an admin.
  ///
  /// The test attempt is the [codeAttempt], which will be compared to
  /// the [adminCode] that is stored in the database. TODO: fetch admin code
  /// elsewhere, pass it in as [id]. [_onComplete] will set the state of the
  /// parent widget with the value of the result; either true (user is now
  /// an admin) or false (user failed to become admin).
  static Future<bool> adminAttempt(
      String codeAttempt, int id, Function(Future<bool>) _onComplete) {
    /// Fetch the admin code from the database.
    Future<bool> result =
        Future<bool>.value(Toolkit.stream.first.then((QuerySnapshot snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.documents.elementAt(0);
      int adminCode = documentSnapshot.data['admin_code'];

      if (codeAttempt == adminCode.toString()) {
        /// Write the result to [SharedPreferences].
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

  /// Make an attempt to become a manager of a specific competition.
  ///
  /// The test attempt is the [codeAttempt], which will be compared to the [id],
  /// which is the [id] field of the [currentData] of the competition which the
  /// user is trying to gain access to. [_onComplete] is called to set the state
  /// of the parent widget with the result.
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

  Privileges({@required this.isAdmin, @required this.competitionAccess});
}
