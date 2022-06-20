import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/admin/controll/student/controll_student_info.dart';
import 'package:repiton/screens/admin/controll/teacher/controll_teacher_info.dart';
import 'package:repiton/widgets/controll_list_widget.dart';
import 'package:repiton/widgets/state_chooser.dart';

class ControllScreen extends StatefulWidget {
  const ControllScreen({Key? key}) : super(key: key);

  @override
  State<ControllScreen> createState() => _ControllScreenState();
}

class _ControllScreenState extends State<ControllScreen> {
  final List<String> _states = ["Преподаватели", "Ученики"];
  late String _state = _states[0];

  Future<void> getData() {
    if (_state == _states[1]) {
      return RootProvider.getUsers().fetchStudents();
    } else {
      return RootProvider.getUsers().fetchTeachers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Статистика",
              style: TextStyle(
                fontSize: 34,
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: "Поиск",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                    ),
                    onPressed: () {
                      debugPrint("Cancel search");
                    },
                  )),
            ),
            StateChooser(
              items: _states,
              onStateChange: (newValue) {
                setState(() {
                  _state = newValue;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Consumer(builder: (context, ref, _) {
                      final users = ref.watch(RootProvider.getUsersProvider());

                      return _states.indexOf(_state) == 1
                          ? ListView.separated(
                              itemBuilder: (context, index) => ControllListWidget(
                                name: users.studentsList[index].fullName,
                                imageUrl: users.studentsList[index].imageUrl,
                                user: users.studentsList[index],
                                page: (user) => ControllStudentInfo(
                                  student: (user as Student),
                                ),
                              ),
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: users.studentsList.length,
                            )
                          : ListView.separated(
                              itemBuilder: (context, index) => ControllListWidget(
                                name: users.teachersList[index].fullName,
                                imageUrl: users.teachersList[index].imageUrl,
                                user: users.teachersList[index],
                                page: (user) => ControllTeacherInfo(teacher: (user as Teacher)),
                              ),
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: users.teachersList.length,
                            );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
