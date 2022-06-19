import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton_api/entities/user_auth_request.dart';
import 'package:repiton_api/entities/user_auth_response.dart';

abstract class IAuthRepo {
  Future<UserAuthResponse?> auth(String? login, String? email, String password);
  Future<UserAuthResponse?> getUserInfo();
}

class AuthRepo implements IAuthRepo {
  RepitonApiContainer get _api => GetIt.I.get<RepitonApiContainer>();

  @override
  Future<UserAuthResponse?> auth(String? login, String? email, String password) async {
    try {
      return await _api.auth.auth(body: UserAuthRequest(email: email, username: login, password: password));
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }

  @override
  Future<UserAuthResponse?> getUserInfo() async {
    try {
      return await _api.auth.getUserInfo();
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }
}
