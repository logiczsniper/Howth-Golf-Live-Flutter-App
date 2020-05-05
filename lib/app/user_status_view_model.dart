import 'package:flutter/foundation.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatusViewModel extends ChangeNotifier {
  bool _isAdmin;

  /// A list of [DatabaseEntry.id] which this device has access to.
  List<String> _competitionAccess = [];
  List<String> _visitedRoutes = [];

  List<String> get competitionAccess => _competitionAccess ?? [];
  List<String> get visitedRoutes => _visitedRoutes ?? [];

  bool get isAdmin => _isAdmin ?? false;
  bool isManager(int id) =>
      competitionAccess.contains(id.toString()) || isAdmin;

  bool hasVisited(String route) => visitedRoutes.contains(route);
  bool hasAccess(int id) => isAdmin || isManager(id);

  /// Determines whether or not the user is verified.
  ///
  /// If the user is at the [HelpsPage] then they are classified as
  /// 'verified' if they are an admin.
  ///
  /// If the user is elsewhere, they are 'verified' if they are an admin
  /// or they are a manager of the competition which they are currently at.
  bool isVerified(String title, {int id = 0}) {
    switch (title) {
      case Strings.helpsText:
        return isAdmin;
        break;
      default:
        return isAdmin || competitionAccess.contains(id.toString());
    }
  }

  UserStatusViewModel() {
    loadUserStatus();
  }

  /// Fetch the user status using [SharedPreferences].
  void loadUserStatus() async {
    final preferences = await SharedPreferences.getInstance();

    _isAdmin = preferences.getBool(Strings.activeAdminText) ?? false;
    _competitionAccess =
        preferences.getStringList(Strings.activeCompetitionsText) ?? [];
    _visitedRoutes = preferences.getStringList(Strings.visitedRoutes) ?? [];
    notifyListeners();
  }

  void clearPreferences() async {
    final preferences = await SharedPreferences.getInstance();

    preferences.clear();
    notifyListeners();
  }

  void visitRoute(String route) async {
    final preferences = await SharedPreferences.getInstance();

    _visitedRoutes.add(route);
    preferences.setStringList(Strings.visitedRoutes, _visitedRoutes);
    notifyListeners();
  }

  void clearVisitedRoutes() async {
    final preferences = await SharedPreferences.getInstance();

    _visitedRoutes.clear();
    preferences.setStringList(Strings.visitedRoutes, _visitedRoutes);
    notifyListeners();
  }

  Future<bool> adminAttempt(String codeAttempt, String actualCode) async {
    final preferences = await SharedPreferences.getInstance();

    if (codeAttempt == actualCode) {
      _isAdmin = true;
      preferences.setBool(Strings.activeAdminText, _isAdmin);
      notifyListeners();
    }

    return codeAttempt == actualCode;
  }

  Future<bool> managerAttempt(String codeAttempt, String actualCode) async {
    final preferences = await SharedPreferences.getInstance();

    if (codeAttempt == actualCode) {
      _competitionAccess.add(actualCode);
      preferences.setStringList(
          Strings.activeCompetitionsText, _competitionAccess);
      notifyListeners();
    }

    return codeAttempt == actualCode;
  }

  /// Get the additional help entries count based on their user status.
  ///
  /// If they are a manager, they get an extra one which explains how to update
  /// hole data.
  ///
  /// If they are an admin, they get the manager level entry and an entry explaining
  /// how to update competition data.
  int get bonusHelpEntries {
    if (isAdmin)
      return 0;
    else if (competitionAccess.isNotEmpty)
      return -1;
    else
      return -2;
  }
}
