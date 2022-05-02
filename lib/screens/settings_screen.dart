import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/provider/student/students.dart';
import 'package:repiton/provider/teacher/teachers.dart';

class SettingsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final _auth = RootProvider.getAuth;

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
              if (RootProvider.getAuth.userRole.length > 1)
                Consumer(
                  builder: (context, ref, _) {
                    final auth = ref.watch(RootProvider.getAuthProvider);
                    return IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () {
                        auth.changeRoles();
                      },
                      icon: const Icon(Icons.change_circle_outlined),
                    );
                  },
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
                    if (_auth.userRole[0] == AuthProvider.teacherRole) {
                      return getUserNameAndRole<Teacher>(
                        RootProvider.getTeachers.getCachedTeacher(),
                        (teacher) {
                          return teacher.lastName + " " + teacher.name + " " + teacher.fatherName;
                        },
                        "Преподаватель",
                      );
                    } else if (_auth.userRole[0] == AuthProvider.adminRole) {
                      // TODO: Change to admin provider
                      return getUserNameAndRole<Teacher>(
                        RootProvider.getTeachers.getCachedTeacher(),
                        (teacher) {
                          return teacher.lastName + " " + teacher.name + " " + teacher.fatherName;
                        },
                        "Администратор",
                      );
                    } else if (_auth.userRole[0] == AuthProvider.studentRole) {
                      return getUserNameAndRole<Student>(
                        RootProvider.getStudents.getCachedStudent(),
                        (student) {
                          return student.lastName + " " + student.name;
                        },
                        "Ученик",
                      );
                    } else {
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
