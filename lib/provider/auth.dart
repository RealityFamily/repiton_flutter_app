import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton/repos/auth_repo.dart';

class AuthProvider with ChangeNotifier {
  static const String adminRole = "admin";
  static const String teacherRole = "teacher";
  static const String studentRole = "student";

  final IAuthRepo _repo;

  AuthProvider(this._repo);

  String? _id = "t1";
  String? _userName = "leonis13579";
  String? _token;
  String? _refresh;
  List<String> _userRole = [];

  void changeRoles() {
    if (_userRole.length > 1) {
      _userRole.insert(1, _userRole.removeAt(0));
      notifyListeners();
    }
  }

  Future<void> auth(String? login, String? email, String password) async {
    final response = await _repo.auth(login, email, password);
    _id = response.id;
    _userName = response.userName;
    _token = response.token;
    _refresh = response.refreshToken;
    _userRole = response.roles;

    GetIt.I.get<RepitonApiContainer>().setToken(_token);

    debugPrint(_token);
  }

  List<String> get userRole {
    return [..._userRole];
  }

  String get id {
    return _id ?? "";
  }

  String get userName {
    return _userName ?? "";
  }

  String get authToken {
    return _token ?? "";
  }

  String get refresh {
    return _refresh ?? "";
  }
}
