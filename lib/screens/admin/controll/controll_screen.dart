import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/admin/users.dart';
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
      return Provider.of<Users>(context, listen: false).fetchStudents();
    } else {
      return Provider.of<Users>(context, listen: false).fetchTeachers();
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
                    return Consumer<Users>(
                      builder: (context, users, _) => _states.indexOf(_state) == 1
                          ? ListView.separated(
                              itemBuilder: (context, index) => ControllListWidget(
                                name: users.studentsList[index].lastName + " " + users.studentsList[index].name,
                                imageUrl: users.studentsList[index].imageUrl,
                                id: users.studentsList[index].id,
                                page: (id) => ControllStudentInfo(id: id),
                              ),
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: users.studentsList.length,
                            )
                          : ListView.separated(
                              itemBuilder: (context, index) => ControllListWidget(
                                name: users.teachersList[index].lastName +
                                    " " +
                                    users.teachersList[index].name +
                                    " " +
                                    users.teachersList[index].fatherName,
                                imageUrl: users.teachersList[index].imageUrl,
                                id: users.teachersList[index].id,
                                page: (id) => ControllTeacherInfo(id: id),
                              ),
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: users.teachersList.length,
                            ),
                    );
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
