import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/auth.dart';
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
    final _authProvider = Provider.of<Auth>(context);

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
              if (Provider.of<Auth>(context).userRole.contains(Auth.admin))
                Consumer<Auth>(
                  builder: (context, auth, _) => IconButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: () {
                      auth.changeRoles();
                    },
                    icon: const Icon(Icons.change_circle_outlined),
                  ),
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
                    if (_authProvider.userRole[0] == Auth.teacher) {
                      return getUserNameAndRole<Teacher>(
                        Provider.of<Teachers>(context, listen: false).getCachedTeacher(),
                        (teacher) {
                          return teacher.lastName + " " + teacher.name + " " + teacher.fatherName;
                        },
                        "Преподаватель",
                      );
                    } else if (_authProvider.userRole[0] == Auth.admin) {
                      return getUserNameAndRole<Teacher>(
                        Provider.of<Teachers>(context, listen: false).getCachedTeacher(),
                        (teacher) {
                          return teacher.lastName + " " + teacher.name + " " + teacher.fatherName;
                        },
                        "Администратор",
                      );
                    } else if (_authProvider.userRole[0] == Auth.student) {
                      return getUserNameAndRole<Student>(
                        Provider.of<Students>(context, listen: false).getCachedStudent(),
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
