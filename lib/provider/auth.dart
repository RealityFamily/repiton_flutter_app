import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  String? _authToken;
  List<String> _userRole = ["ADMIN", "TEACHER"];

  void changeRoles() {
    if (_userRole.length > 1) {
      _userRole.insert(1, _userRole.removeAt(0));
      notifyListeners();
    }
  }

  List<String> get userRole {
    return [..._userRole];
  }

  String get authToken {
    return _authToken ?? "";
  }
}
