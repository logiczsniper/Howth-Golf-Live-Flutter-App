import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:howth_golf_live/constants/strings.dart';

class AuthenticationViewModel extends ChangeNotifier {
  String _status;

  AuthenticationViewModel() {
    FirebaseAuth.instance.signOut();
    _status = Strings.tapMe;
  }

  String get status => _status ?? "";

  set status(String newStatus) => _status = newStatus;

  void anonymousSignIn(context) async {
    try {
      _status = Strings.loading;
      notifyListeners();
      await FirebaseAuth.instance
          .signInAnonymously()
          .timeout(Duration(seconds: 15), onTimeout: () => throw Exception)
          .then((_) {
        _status = Strings.connected;
        notifyListeners();
      });
    } catch (_) {
      _status = Strings.failure;
      notifyListeners();
    }
  }
}