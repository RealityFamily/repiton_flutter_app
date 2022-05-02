import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/admin/users.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/provider/student/students.dart';
import 'package:repiton/provider/teacher/teachers.dart';
import 'package:repiton/widgets/add_student_info.dart';
import 'package:repiton/widgets/add_student_parent_info.dart';
import 'package:repiton/widgets/add_teacher_info.dart';

class AddingAccountScreen extends StatefulWidget {
  final Teacher teacher = Teacher.empty();
  final Student student = Student.empty();
  final String? teacherFrom;
  final AddingState state;

  AddingAccountScreen({required this.state, this.teacherFrom, Key? key}) : super(key: key);

  @override
  State<AddingAccountScreen> createState() => _AddingAccountScreenState();
}

class _AddingAccountScreenState extends State<AddingAccountScreen> {
  final parentList = [AddStudentParentInfo()];
  final GlobalKey<FormState> studentFormKey = GlobalKey();
  final GlobalKey<FormState> teacherFormKey = GlobalKey();

  bool _checkAllParents() {
    for (AddStudentParentInfo parent in parentList) {
      if (!parent.formKey.currentState!.validate()) {
        return false;
      }
    }
    return true;
  }

  void _submit() {
    if (widget.state == AddingState.student) {
      if (!studentFormKey.currentState!.validate() || !_checkAllParents()) {
        return;
      }
      studentFormKey.currentState!.save();
      for (AddStudentParentInfo parent in parentList) {
        parent.formKey.currentState!.save();
        widget.student.parents.add(parent.result);
      }
      if (widget.teacherFrom != null) {
        RootProvider.getTeachers.registerStudent(widget.student);
      } else {
        Provider.of<Users>(context, listen: false).addStudent(widget.student);
      }
    } else {
      if (!teacherFormKey.currentState!.validate()) {
        return;
      }
      teacherFormKey.currentState!.save();

      Provider.of<Users>(context, listen: false).addTeacher(widget.teacher);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    "Добавление",
                    style: TextStyle(
                      fontSize: 34,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(16),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: widget.state == AddingState.student
                      ? Column(
                          children: [
                            AddStudentInfo(
                              formKey: studentFormKey,
                              result: widget.student,
                            ),
                            const SizedBox(
                              height: 23,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Введите данные родителя ученика",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      parentList.add(AddStudentParentInfo());
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = parentList[index];
                                return Dismissible(
                                  key: ObjectKey(item),
                                  background: Container(
                                    color: Colors.red,
                                  ),
                                  child: item,
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    if (direction == DismissDirection.endToStart) {
                                      setState(() {
                                        if (parentList.length > 1) {
                                          parentList.remove(item);
                                        }
                                      });
                                    }
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 36,
                              ),
                              itemCount: parentList.length,
                            ),
                          ],
                        )
                      : AddTeacherInfo(
                          formKey: teacherFormKey,
                          result: widget.teacher,
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Сохранить"),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AddingState {
  student,
  teacher,
}
