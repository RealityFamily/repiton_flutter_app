import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/students.dart';
import 'package:repiton/provider/teachers.dart';
import 'package:repiton/screens/controll_student_info.dart';
import 'package:repiton/screens/controll_teacher_info.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Ведение",
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
              child: _states.indexOf(_state) == 1
                  ? Consumer<Students>(
                      builder: (context, students, child) => ListView.separated(
                        itemBuilder: (context, index) => ControllListWidget(
                          name: students.students[index].lastName +
                              " " +
                              students.students[index].name,
                          imageUrl: students.students[index].imageUrl,
                          id: students.students[index].id,
                          page: (id) => ControllStudentInfo(id: id),
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: students.students.length,
                      ),
                    )
                  : Consumer<Teachers>(
                      builder: (context, teachers, child) => ListView.separated(
                        itemBuilder: (context, index) => ControllListWidget(
                          name: teachers.teachers[index].lastName +
                              " " +
                              teachers.teachers[index].name +
                              " " +
                              teachers.teachers[index].fatherName,
                          imageUrl: teachers.teachers[index].imageUrl,
                          id: teachers.teachers[index].id,
                          page: (id) => ControllTeacherInfo(id: id),
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: teachers.teachers.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
