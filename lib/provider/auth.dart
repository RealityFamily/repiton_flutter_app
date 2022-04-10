import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  static final Role admin = Role(name: "ADMIN");
  static final Role teacher = Role(name: "TEACHER");
  static final Role student = Role(name: "STUDENT");

  String? _id = "t1";
  String? _userName = "leonis13579";
  String? _token;
  String? _refresh;
  final List<Role> _userRole = [
    Role(name: "ADMIN"),
    Role(name: "TEACHER"),
  ];

  void changeRoles() {
    if (_userRole.length > 1) {
      _userRole.insert(1, _userRole.removeAt(0));
      notifyListeners();
    }
  }

  List<Role> get userRole {
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

class Role {
  late String id;
  String name;

  Role({required this.name}) {
    id = "r_$name";
  }

  @override
  bool operator ==(Object other) {
    if (other is! Role) {
      return false;
    }
    return name == other.name;
  }

  @override
  int get hashCode => id.hashCode;
}
