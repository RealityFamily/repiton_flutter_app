import 'package:flutter/foundation.dart';
import 'package:repiton/model/admin.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/repos/admin_repo.dart';

class AdminsProvider with ChangeNotifier {
  Admin? _admin;
  final IAdminRepo _repo;

  AdminsProvider(this._repo);

  Future<Admin> get cachedAdmin async {
    _admin ??= await _repo.getAdminById(RootProvider.getAuth().id);
    return _admin!;
  }
}
