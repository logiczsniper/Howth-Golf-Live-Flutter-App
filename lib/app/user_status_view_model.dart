import 'package:flutter/foundation.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatusViewModel extends ChangeNotifier {
  final String _activeAdminText = "activeAdmin";
  final String _activeCompetitionsText = "activeCompetitions";

  bool _isAdmin;
  List<String> _competitionAccess = [];

  List<String> get competitionAccess => _competitionAccess ?? [];
  bool get isAdmin => _isAdmin ?? false;
  bool isManager(int id) =>
      competitionAccess.contains(id.toString()) || isAdmin;
  bool hasAccess(int id) => isAdmin || isManager(id);

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

  void loadUserStatus() async {
    final preferences = await SharedPreferences.getInstance();

    _isAdmin = preferences.getBool(_activeAdminText) ?? false;
    _competitionAccess =
        preferences.getStringList(_activeCompetitionsText) ?? [];
    notifyListeners();
  }

  void clearPreferences() async {
    final preferences = await SharedPreferences.getInstance();

    preferences.clear();
    notifyListeners();
  }

  Future<bool> adminAttempt(String codeAttempt, String actualCode) async {
    final preferences = await SharedPreferences.getInstance();

    if (codeAttempt == actualCode) {
      _isAdmin = true;
      preferences.setBool(_activeAdminText, _isAdmin);
      notifyListeners();
    }

    return codeAttempt == actualCode;
  }

  Future<bool> managerAttempt(String codeAttempt, String actualCode) async {
    final preferences = await SharedPreferences.getInstance();

    if (codeAttempt == actualCode) {
      _competitionAccess.add(actualCode);
      preferences.setStringList(_activeCompetitionsText, _competitionAccess);
      notifyListeners();
    }

    return codeAttempt == actualCode;
  }

  int get bonusEntries {
    if (isAdmin)
      return 1;
    else if (competitionAccess.isNotEmpty)
      return 0;
    else
      return -1;
  }
}
