import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/students.dart';
import 'package:repiton/provider/teachers.dart';
import 'package:repiton/widgets/controll_list_widget.dart';

class ControllScreen extends StatefulWidget {
  const ControllScreen({Key? key}) : super(key: key);

  @override
  State<ControllScreen> createState() => _ControllScreenState();
}

class _ControllScreenState extends State<ControllScreen> {
  ControllState state = ControllState.teacher;

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
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 21,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        primary: state == ControllState.teacher
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          state = ControllState.teacher;
                        });
                      },
                      child: Text(
                        "Преподаватель",
                        style: TextStyle(
                          color: state == ControllState.student
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          state = ControllState.student;
                        });
                      },
                      child: Text(
                        "Ученик",
                        style: TextStyle(
                          color: state == ControllState.teacher
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        primary: state == ControllState.student
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state == ControllState.student
                  ? Consumer<Students>(
                      builder: (context, students, child) => ListView.separated(
                        itemBuilder: (context, index) => ControllListWidget(
                          name: students.students[index].lastName +
                              " " +
                              students.students[index].name,
                          imageUrl: students.students[index].imageUrl,
                          id: students.students[index].id,
                          state: state,
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
                          state: state,
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

enum ControllState {
  teacher,
  student,
}
