import 'package:flutter/material.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/widgets/add_student_info.dart';
import 'package:repiton/widgets/add_student_parent_info.dart';
import 'package:repiton/widgets/add_teacher_info.dart';

class AddingAccountScreen extends StatefulWidget {
  final Teacher teacher = Teacher.empty();
  final Student student = Student.empty();

  AddingAccountScreen({Key? key}) : super(key: key);

  @override
  State<AddingAccountScreen> createState() => _AddingAccountScreenState();
}

class _AddingAccountScreenState extends State<AddingAccountScreen> {
  AddingState state = AddingState.student;
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
    if (state == AddingState.student) {
      if (!studentFormKey.currentState!.validate() || !_checkAllParents()) {
        return;
      }
      studentFormKey.currentState!.save();
      for (AddStudentParentInfo parent in parentList) {
        parent.formKey.currentState!.save();
        widget.student.parents.add(parent.result);
      }

      //TODO: Send new student
      debugPrint(widget.student.toString());
    } else {
      if (!teacherFormKey.currentState!.validate()) {
        return;
      }
      teacherFormKey.currentState!.save();

      //TODO: Send new teacher
      debugPrint(widget.teacher.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Добавление",
              style: TextStyle(
                fontSize: 34,
              ),
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
                        primary: state == AddingState.student
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
                          state = AddingState.student;
                        });
                      },
                      child: Text(
                        "Ученик",
                        style: TextStyle(
                          color: state == AddingState.teacher
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
                          state = AddingState.teacher;
                        });
                      },
                      child: Text(
                        "Преподаватель",
                        style: TextStyle(
                          color: state == AddingState.student
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        primary: state == AddingState.teacher
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
              child: SingleChildScrollView(
                child: state == AddingState.student
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
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    setState(() {
                                      if (parentList.length > 1) {
                                        parentList.remove(item);
                                      }
                                    });
                                  }
                                },
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
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
    );
  }
}

enum AddingState {
  teacher,
  student,
}
