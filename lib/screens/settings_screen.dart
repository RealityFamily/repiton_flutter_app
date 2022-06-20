import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/auth_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Widget _getUserNameAndRole<T>(Future<T> futureAction, String Function(T) userName, String userRole) {
    return FutureBuilder<T>(
      future: futureAction,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: userName(snapshot.data!),
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: "\n" + userRole,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _getUserNameAndRoleFromRole(String userRole) {
    if (userRole == AuthProvider.teacherRole) {
      return _getUserNameAndRole<Teacher>(
        RootProvider.getTeachers().cachedTeacher(),
        (teacher) {
          return teacher.lastName + " " + teacher.name + " " + teacher.fatherName;
        },
        "Преподаватель",
      );
    } else if (userRole == AuthProvider.adminRole) {
      // TODO: Change to admin provider
      return _getUserNameAndRole<Teacher>(
        RootProvider.getTeachers().cachedTeacher(),
        (teacher) {
          return teacher.lastName + " " + teacher.name + " " + teacher.fatherName;
        },
        "Администратор",
      );
    } else if (userRole == AuthProvider.studentRole) {
      return _getUserNameAndRole<Student>(
        RootProvider.getStudents().getCachedStudent(),
        (student) {
          return student.lastName + " " + student.name;
        },
        "Ученик",
      );
    } else {
      debugPrint(userRole[0]);
      return Container();
    }
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthScreen()));
    RootProvider.getAuth().logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(RootProvider.getAuthProvider());

    return SafeArea(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Настройки",
                    style: TextStyle(
                      fontSize: 34,
                    ),
                  )
                ],
              ),
              if (_auth.isMultiRoleUser)
                IconButton(
                  padding: const EdgeInsets.all(16),
                  onPressed: () {
                    _auth.changeRoles();
                  },
                  icon: const Icon(Icons.change_circle_outlined),
                ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  _getUserNameAndRoleFromRole(_auth.userRole),
                  Expanded(child: Container()),
                  TextButton(
                    onPressed: () => _logout(context),
                    child: Text("Выход"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
