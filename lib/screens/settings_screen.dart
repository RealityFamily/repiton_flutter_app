import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Widget getUserNameAndRole<T>(Future<T> futureAction, String Function(T) userName, String userRole) {
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
                  (() {
                    if (_auth.userRole == AuthProvider.teacherRole) {
                      return getUserNameAndRole<Teacher>(
                        RootProvider.getTeachers().getCachedTeacher(),
                        (teacher) {
                          return teacher.lastName + " " + teacher.name + " " + teacher.fatherName;
                        },
                        "Преподаватель",
                      );
                    } else if (_auth.userRole == AuthProvider.adminRole) {
                      // TODO: Change to admin provider
                      return getUserNameAndRole<Teacher>(
                        RootProvider.getTeachers().getCachedTeacher(),
                        (teacher) {
                          return teacher.lastName + " " + teacher.name + " " + teacher.fatherName;
                        },
                        "Администратор",
                      );
                    } else if (_auth.userRole == AuthProvider.studentRole) {
                      return getUserNameAndRole<Student>(
                        RootProvider.getStudents().getCachedStudent(),
                        (student) {
                          return student.lastName + " " + student.name;
                        },
                        "Ученик",
                      );
                    } else {
                      debugPrint(_auth.userRole[0]);
                      return Container();
                    }
                  }())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
