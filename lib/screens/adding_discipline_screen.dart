import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/widgets/add_discipline_info.dart';
import 'package:repiton/widgets/add_student_info.dart';
import 'package:repiton/widgets/add_student_parent_info.dart';

class AddingDisciplineScreen extends StatefulWidget {
  final String? initTeacherId;

  const AddingDisciplineScreen({this.initTeacherId, Key? key}) : super(key: key);

  @override
  State<AddingDisciplineScreen> createState() => _AddingDisciplineScreenState();
}

class _AddingDisciplineScreenState extends State<AddingDisciplineScreen> {
  final parentList = [AddStudentParentInfo(parentTitle: "Родитель 1")];
  final GlobalKey<FormState> studentFormKey = GlobalKey();
  final GlobalKey<FormState> teacherFormKey = GlobalKey();
  final Student student = Student.empty();
  final Discipline discipline = Discipline.empty();

  bool _checkAllParents() {
    for (AddStudentParentInfo parent in parentList) {
      if (!parent.formKey.currentState!.validate()) {
        return false;
      }
    }
    return true;
  }

  void _submit() {
    if (!studentFormKey.currentState!.validate() || !_checkAllParents()) {
      return;
    }
    studentFormKey.currentState!.save();
    for (AddStudentParentInfo parent in parentList) {
      parent.formKey.currentState!.save();
      student.parents.add(parent.result);
    }
    RootProvider.getUsers().addStudent(student);
  }

  Widget get _addingScreenBuild {
    if (MediaQuery.of(context).size.width < 950) {
      return _tinyScreanBuild;
    } else {
      return _wideScreanBuild;
    }
  }

  Widget get _tinyScreanBuild => SingleChildScrollView(
        child: Column(
          children: [
            AddStudentInfo(formKey: studentFormKey, result: student),
            const SizedBox(height: 36),
            AddDisciplineInfo(result: discipline, formKey: studentFormKey, initTeacherId: widget.initTeacherId),
            const SizedBox(height: 23),
            _parentInputForm,
          ],
        ),
      );

  Widget get _wideScreanBuild => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(padding: const EdgeInsets.all(16), child: SingleChildScrollView(child: AddStudentInfo(formKey: studentFormKey, result: student))),
                ),
                const Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(child: AddDisciplineInfo(result: discipline, formKey: studentFormKey, initTeacherId: widget.initTeacherId)),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(child: Padding(padding: const EdgeInsets.all(16), child: SingleChildScrollView(child: _parentInputForm))),
        ],
      );

  Widget get _parentInputForm => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: Text("Введите данные родителя ученика", style: TextStyle(fontSize: 22))),
              IconButton(
                onPressed: () => setState(() => parentList.add(AddStudentParentInfo(parentTitle: "Родитель ${parentList.length + 1}"))),
                icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
          const SizedBox(height: 13),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => _parentListItem(parentList[index]),
            separatorBuilder: (_, __) => const SizedBox(height: 36),
            itemCount: parentList.length,
          ),
        ],
      );

  Widget get _saveStudentAccountButton => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: kIsWeb ? const EdgeInsets.symmetric(vertical: 16, horizontal: 24) : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        onPressed: _submit,
        child: const Text("Сохранить", style: TextStyle(fontSize: 18)),
      );

  Widget _parentListItem(AddStudentParentInfo item) {
    if (kIsWeb) {
      item.onDeleteButtonPressed = () => _onDeleteParentItemFromList(item);
      return item;
    } else {
      return Dismissible(
        key: ObjectKey(item),
        background: Container(color: Colors.red),
        child: item,
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) _onDeleteParentItemFromList(item);
        },
      );
    }
  }

  void _onDeleteParentItemFromList(AddStudentParentInfo item) {
    setState(() {
      if (parentList.length > 1) {
        parentList.remove(item);
      }
    });
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
              _saveStudentAccountButton,
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
