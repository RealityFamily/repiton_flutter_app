import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/provider/admin/students_statistics.dart';
import 'package:repiton/provider/admin/teachers_statistics.dart';
import 'package:repiton/provider/admin/users.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/lessons.dart';
import 'package:repiton/provider/rocket_chat_messages.dart';
import 'package:repiton/provider/student/students.dart';
import 'package:repiton/provider/student/students_lessons.dart';
import 'package:repiton/provider/teacher/teachers.dart';
import 'package:repiton/provider/teacher/teachers_lessons.dart';
import 'package:repiton/repos/admin_repo.dart';
import 'package:repiton/repos/auth_repo.dart';
import 'package:repiton/repos/lesson_repo.dart';
import 'package:repiton/repos/student_repo.dart';
import 'package:repiton/repos/teacher_repo.dart';

class RootProvider {
  static T _getAndRegister<T extends Object>(T Function() construct, {bool refresh = false}) {
    if (!GetIt.I.isRegistered<T>() || refresh) {
      GetIt.I.registerSingleton<T>(construct());
    }
    return GetIt.I.get<T>();
  }

  static void refreshRootProvider() {
    GetIt.I.unregister<AuthProvider>();
    GetIt.I.unregister<RocketChatMessagesProvider>();
    GetIt.I.unregister<LessonsProvider>();

    GetIt.I.unregister<TeachersProvider>();
    GetIt.I.unregister<TeachersLessonsProvider>();

    GetIt.I.unregister<StudentsProvider>();

    GetIt.I.unregister<UsersProvider>();
    GetIt.I.unregister<StudentsStatisticsProvider>();
    GetIt.I.unregister<TearchersStatiscticsProvider>();
  }

  /// General providers

  static AuthProvider getAuth({bool refresh = false}) => _getAndRegister(() => AuthProvider(AuthRepo()), refresh: refresh);
  static ChangeNotifierProvider<AuthProvider> getAuthProvider({bool refresh = false}) => ChangeNotifierProvider<AuthProvider>(
        (ref) {
          return _getAndRegister(() => AuthProvider(AuthRepo()), refresh: refresh);
        },
      );

  static RocketChatMessagesProvider getRocketChatMessages({bool refresh = false}) => _getAndRegister(() => RocketChatMessagesProvider(), refresh: refresh);
  static ChangeNotifierProvider<RocketChatMessagesProvider> getRocketChatMessagesProvider({bool refresh = false}) => ChangeNotifierProvider<RocketChatMessagesProvider>(
        (ref) {
          return _getAndRegister(() => RocketChatMessagesProvider(), refresh: refresh);
        },
      );

  static LessonsProvider getLessons({bool refresh = false}) => _getAndRegister(() => LessonsProvider(LessonRepo()), refresh: refresh);
  static ChangeNotifierProvider<LessonsProvider> getLessonsProvider({bool refresh = false}) => ChangeNotifierProvider<LessonsProvider>(
        (ref) {
          return _getAndRegister(() => LessonsProvider(LessonRepo()), refresh: refresh);
        },
      );

  /// Teachers providers

  static TeachersProvider getTeachers({bool refresh = false}) => _getAndRegister(() => TeachersProvider(TeacherRepo()), refresh: refresh);
  static ChangeNotifierProvider<TeachersProvider> getTeachersProvider({bool refresh = false}) => ChangeNotifierProvider<TeachersProvider>(
        (ref) {
          return _getAndRegister(() => TeachersProvider(TeacherRepo()), refresh: refresh);
        },
      );

  static TeachersLessonsProvider getTeachersLessons({bool refresh = false}) => _getAndRegister(() => TeachersLessonsProvider(TeacherRepo()), refresh: refresh);
  static ChangeNotifierProvider<TeachersLessonsProvider> getTeachersLessonsProvider({bool refresh = false}) => ChangeNotifierProvider<TeachersLessonsProvider>(
        (ref) {
          return _getAndRegister(() => TeachersLessonsProvider(TeacherRepo()), refresh: refresh);
        },
      );

  /// Students providers

  static StudentsProvider getStudents({bool refresh = false}) => _getAndRegister(() => StudentsProvider(StudentRepo()), refresh: refresh);
  static ChangeNotifierProvider<StudentsProvider> getStudentsProvider({bool refresh = false}) => ChangeNotifierProvider<StudentsProvider>(
        (ref) {
          return _getAndRegister(() => StudentsProvider(StudentRepo()), refresh: refresh);
        },
      );

  static StudentLessonsProvider getStudentLessons({bool refresh = false}) => _getAndRegister(() => StudentLessonsProvider(StudentRepo()), refresh: refresh);
  static ChangeNotifierProvider<StudentLessonsProvider> getStudentLessonsProvider({bool refresh = false}) => ChangeNotifierProvider<StudentLessonsProvider>(
        (ref) {
          return _getAndRegister(() => StudentLessonsProvider(StudentRepo()), refresh: refresh);
        },
      );

  /// Admins providers

  static UsersProvider getUsers({bool refresh = false}) => _getAndRegister(() => UsersProvider(AdminRepo()), refresh: refresh);
  static ChangeNotifierProvider<UsersProvider> getUsersProvider({bool refresh = false}) => ChangeNotifierProvider<UsersProvider>(
        (ref) {
          return _getAndRegister(() => UsersProvider(AdminRepo()), refresh: refresh);
        },
      );

  static StudentsStatisticsProvider getStudentsStatistics({bool refresh = false}) => _getAndRegister(() => StudentsStatisticsProvider(), refresh: refresh);
  static ChangeNotifierProvider<StudentsStatisticsProvider> getStudentsStatisticsProvider({bool refresh = false}) => ChangeNotifierProvider<StudentsStatisticsProvider>(
        (ref) {
          return _getAndRegister(() => StudentsStatisticsProvider(), refresh: refresh);
        },
      );

  static TearchersStatiscticsProvider getTearchersStatisctics({bool refresh = false}) => _getAndRegister(() => TearchersStatiscticsProvider(), refresh: refresh);
  static ChangeNotifierProvider<TearchersStatiscticsProvider> getTearchersStatiscticsProvider({bool refresh = false}) =>
      ChangeNotifierProvider<TearchersStatiscticsProvider>(
        (ref) {
          return _getAndRegister(() => TearchersStatiscticsProvider(), refresh: refresh);
        },
      );
}
