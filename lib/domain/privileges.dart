import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/domain/firebase_interation.dart';
import 'package:howth_golf_live/domain/models.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// When getting data from preferences, it is vital that these values are used as keys.
const String _activeAdminText = "activeAdmin";
const String _activeCompetitionsText = "activeCompetitions";

class Privileges {
  /// Whether or not the user is an admin.
  final bool isAdmin;

  /// The [DatabaseEntry.id] values which the user is a
  /// manager of and thus has access to modify those [DatabaseEntry]
  /// values.
  final List<String> competitionAccess;

  /// Converting preferences into [Privileges] object.
  Privileges.fromPreferences(SharedPreferences preferences)
      : isAdmin = preferences.getBool(_activeAdminText),
        competitionAccess = preferences.getStringList(_activeCompetitionsText);

  Privileges({@required this.isAdmin, @required this.competitionAccess});

  /// Removes all locally stored data, resetting the users privileges.
  static void clearPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  /// Get the instance of [SharedPreferences].
  static Future<SharedPreferences> get _preferences =>
      SharedPreferences.getInstance();

  /// Get whether or not the user [isAdmin].
  ///
  /// If they are, they are granted access to modify any
  /// competition, create and delete competitions.
  static bool adminStatus({@required dynamic context}) {
    assert(context != null);

    final Privileges arguments = Routes.arguments(context);

    /// If the value of [isAdmin] is null, default to [false].
    final bool isAdmin = arguments.isAdmin ?? false;
    return isAdmin;
  }

  /// Get whether or not the user [isManager].
  ///
  /// This would grant them admin privileges however only to
  /// the competition which they are admin of. In this case,
  /// tests if they are an given these rights for [currentEntry].
  static bool managerStatus(DataBaseEntry currentEntry,
      {@required dynamic context}) {
    assert(context != null);

    final Privileges arguments = Routes.arguments(context);

    /// If the list of competitions which the user has access to
    /// is null, default to [false].
    if (arguments.competitionAccess == null) return false;

    final bool isManager =
        arguments.competitionAccess.contains(currentEntry.id.toString());

    return isManager;
  }

  /// Make an attempt to become an admin.
  ///
  /// The test attempt is the [codeAttempt], which will be compared to
  /// the [adminCode] that is stored in the database. [_onComplete] will set the state of the
  /// parent widget with the value of the result; either true (user is now
  /// an admin) or false (user failed to become admin).
  ///
  /// It is crucial that [adminAttempt] and [managerAttempt] have the same
  /// prototype.
  static Future<bool> adminAttempt(
      String codeAttempt, int _, void Function(Future<bool>) _onComplete) {
    /// Fetch the admin code from the database.
    Future<bool> result =
        Future<bool>.value(DataBaseInteraction.adminCode.then((int adminCode) {
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
      String codeAttempt, int id, void Function(Future<bool>) _onComplete) {
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
}
