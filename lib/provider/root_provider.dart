import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/student/students.dart';
import 'package:repiton/provider/teacher/teachers.dart';
import 'package:repiton/repos/auth_repo.dart';

class RootProvider {
  static T _getAndRegister<T extends Object>(T Function() construct) {
    if (!GetIt.I.isRegistered<T>()) {
      GetIt.I.registerSingleton<T>(construct());
    }
    return GetIt.I.get<T>();
  }

  static AuthProvider get getAuth => _getAndRegister(() => AuthProvider(AuthRepo()));
  static ChangeNotifierProvider<AuthProvider> get getAuthProvider => ChangeNotifierProvider<AuthProvider>(
        (ref) {
          return _getAndRegister(() => AuthProvider(AuthRepo()));
        },
      );

  static TeachersProvider get getTeachers => _getAndRegister(() => TeachersProvider());
  static ChangeNotifierProvider<TeachersProvider> get getTeachersProvider => ChangeNotifierProvider<TeachersProvider>(
        (ref) {
          return _getAndRegister(() => TeachersProvider());
        },
      );

  static StudentsProvider get getStudents => _getAndRegister(() => StudentsProvider());
  static ChangeNotifierProvider<StudentsProvider> get getStudentsProvider => ChangeNotifierProvider<StudentsProvider>(
        (ref) {
          return _getAndRegister(() => StudentsProvider());
        },
      );
}
