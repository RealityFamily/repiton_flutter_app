import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton/core/tokenStorage/secure_token_storage.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/repos/auth_repo.dart';

class AuthProvider with ChangeNotifier {
  static const String adminRole = "admin";
  static const String teacherRole = "teacher";
  static const String studentRole = "student";

  final IAuthRepo _repo;

  AuthProvider(this._repo);

  String? _id;
  String? _userName;
  String? _token = GetIt.I.get<SecureTokenStorage>().authToken;
  String? _refresh;
  List<String> _userRole = [];

  void changeRoles() {
    if (_userRole.length > 1) {
      final String first = _userRole.removeAt(0);
      _userRole.add(first);
      notifyListeners();
    }
  }

  Future<bool> auth(String? login, String? email, String password) async {
    final response = await _repo.auth(login, email, password);

    if (response != null) {
      _id = response.id;
      _userName = response.userName;
      _token = response.token;
      _refresh = response.refreshToken;
      _userRole = response.roles;

      if (_token != null) {
        GetIt.I.get<SecureTokenStorage>().setToken(_token!);
        GetIt.I.get<RepitonApiContainer>().setToken(_token!);
      }

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _getUserInfo() async {
    final response = await _repo.getUserInfo();

    if (response != null) {
      _id = response.id;
      _userName = response.userName;
      _refresh = response.refreshToken;
      _userRole = response.roles;

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<Object?> get cachedUserInfo async {
    if (userRole == AuthProvider.adminRole) {
      return await RootProvider.getAdmins().cachedAdmin();
    } else if (userRole == AuthProvider.teacherRole) {
      return await RootProvider.getTeachers().cachedTeacher();
    } else if (userRole == AuthProvider.studentRole) {
      return await RootProvider.getStudents().cachedStudent();
    } else {
      return null;
    }
  }

  void logout() {
    _id = null;
    _userName = null;
    _token = null;
    _refresh = null;
    _userRole = [];

    RootProvider.refreshRootProvider();

    GetIt.I.get<SecureTokenStorage>().deleteToken();
    GetIt.I.get<RepitonApiContainer>().invalidateToken();

    notifyListeners();
  }

  String get userRole {
    if (_userRole.isNotEmpty) {
      return _userRole[0];
    }
    return "Nan";
  }

  bool get isMultiRoleUser => _userRole.length > 1;

  String get id {
    return _id ?? "";
  }

  String get userName {
    return _userName ?? "";
  }

  String get authToken {
    return _token ?? "";
  }

  Future<bool> isAuthenticated() async {
    if (_token != null && _token!.isNotEmpty) {
      return await _getUserInfo();
    } else {
      return false;
    }
  }

  String get refresh {
    return _refresh ?? "";
  }
}
