import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/repos/discipline_repo.dart';
import 'package:repiton/utils/device_size.dart';
import 'package:repiton/widgets/add_discipline_info.dart';
import 'package:repiton/widgets/add_student_info.dart';

class AddingDisciplineScreen extends StatefulWidget {
  final Teacher? initTeacher;
  final Student? initStudent;
  final String? initDisciplineId;

  const AddingDisciplineScreen({this.initStudent, this.initTeacher, this.initDisciplineId, Key? key}) : super(key: key);

  @override
  State<AddingDisciplineScreen> createState() => _AddingDisciplineScreenState();
}

class _AddingDisciplineScreenState extends State<AddingDisciplineScreen> {
  final GlobalKey<FormState> studentFormKey = GlobalKey();
  final GlobalKey<FormState> disciplineFormKey = GlobalKey();
  Student? student;
  Discipline? discipline;

  void _submit() {
    if (!disciplineFormKey.currentState!.validate() || !studentFormKey.currentState!.validate()) {
      return;
    }
    disciplineFormKey.currentState!.save();
    studentFormKey.currentState!.save();
    // for (AddStudentParentInfo parent in parentList) {
    //   parent.formKey.currentState!.save();
    //   student.parents.add(parent.result);
    // }
    if (discipline != null) {
      discipline!.student = student;
      DisciplineRepo().addDiscipline(discipline!);
    }
  }

  Widget get _addingScreenBuild {
    if (DeviceSize.isTinyScreen(context)) {
      return _tinyScreanBuild;
    } else {
      return _wideScreanBuild;
    }
  }

  Widget get _tinyScreanBuild => SingleChildScrollView(
        child: Column(
          children: [
            AddDisciplineInfo(result: (newDiscipline) => discipline = newDiscipline, formKey: disciplineFormKey, initTeacher: widget.initTeacher),
            const SizedBox(height: 36),
            AddStudentInfo(formKey: studentFormKey, result: (newStudent) => student = newStudent, initStudent: widget.initStudent),
          ],
        ),
      );

  Widget get _wideScreanBuild => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: AddDisciplineInfo(result: (newDiscipline) => discipline = newDiscipline, formKey: disciplineFormKey, initTeacher: widget.initTeacher),
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                  child: Column(
                children: [AddStudentInfo(formKey: studentFormKey, result: (newStudent) => student = newStudent, initStudent: widget.initStudent)],
              )),
            ),
          ),
        ],
      );

  Widget get _saveButton => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: kIsWeb ? const EdgeInsets.symmetric(vertical: 16, horizontal: 24) : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        onPressed: _submit,
        child: const Text("Сохранить", style: TextStyle(fontSize: 18)),
      );

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
                  const Text("Добавление", style: TextStyle(fontSize: 34)),
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
              const SizedBox(height: 26),
              Expanded(child: _addingScreenBuild),
              const SizedBox(height: 10),
              _saveButton,
              const SizedBox(height: 10),
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
