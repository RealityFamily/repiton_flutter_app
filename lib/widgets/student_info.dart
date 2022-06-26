import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/parent.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/utils/separated_list.dart';
import 'package:repiton/widgets/add_student_info.dart';
import 'package:repiton/widgets/add_student_parent_info.dart';

class StudentInfo extends StatelessWidget {
  const StudentInfo({Key? key}) : super(key: key);

  Widget _studentInfoGetParents(List<Parent> parents, BuildContext context) {
    List<Widget> content = [];
    if (parents.isNotEmpty) {
      for (int i = 0; i < parents.length; i++) {
        content.add(_studentInfoAParentInfo(i + 1, parents[i]));
        if (i + 1 != parents.length) content.add(const SizedBox(height: 8));
      }
    } else {
      content.add(const Text("Информация о родителях не предоставлена"));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Информация о родителях", style: TextStyle(fontSize: 20)),
            IconButton(icon: const Icon(Icons.add), onPressed: () => _addParentToStudent(context)),
          ],
        ),
        const SizedBox(height: 8),
        ...content,
      ],
    );
  }

  Widget _studentInfoAParentInfo(int parentCount, Parent parent) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Родитель $parentCount"),
              IconButton(onPressed: () => RootProvider.getStudentInfo().deleteParent(parent.id), icon: const Icon(Icons.delete, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 5),
          _studentInfoFormField("Фамилия", parent.lastName),
          const Divider(),
          _studentInfoFormField("Имя", parent.name),
          const Divider(),
          _studentInfoFormField("Отчество", parent.fatherName),
          const Divider(),
          _studentInfoFormField("Телефон", parent.phone),
        ],
      );

  Widget _studentInfoFormField(String title, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title, style: const TextStyle(fontSize: 18)), GestureDetector(child: Text(value))],
      );

  void _changeStudentInfo(BuildContext context) async {
    final newStudentInfo = await showDialog<Student>(
      context: context,
      builder: (_) => _changeStudentInfoDialog(context),
    );
    if (newStudentInfo != null) RootProvider.getStudentInfo().updateStudentInfo(newStudentInfo.copyWith(id: RootProvider.getStudentInfo().student?.id));
  }

  void _addParentToStudent(BuildContext context) async {
    final newParent = await showDialog<Parent>(
      context: context,
      builder: (_) => _addParentDialog(context),
    );
    if (newParent != null) RootProvider.getStudentInfo().addParent(newParent);
  }

  Widget _changeStudentInfoDialog(BuildContext context) {
    Student? studentResult;
    final _formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: const Text("Введите новую информацию об ученике"),
      actions: [
        TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.of(context).pop(studentResult);
              }
            },
            child: const Text("OK")),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Отмена"))
      ],
      content: AddStudentInfo(
        formKey: _formKey,
        result: (newStudent) => studentResult = newStudent,
        isChange: true,
        initStudent: RootProvider.getStudentInfo().student?.copyWith() ?? Student.empty(),
      ),
    );
  }

  Widget _addParentDialog(BuildContext context) {
    final form = AddStudentParentInfo(formKey: GlobalKey<FormState>());

    return AlertDialog(
      title: const Text("Добавте информацию о родителе"),
      actions: [
        TextButton(
            onPressed: () {
              if (form.formKey.currentState!.validate()) {
                form.formKey.currentState!.save();
                Navigator.of(context).pop(form.result);
              }
            },
            child: const Text("OK")),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Отмена"))
      ],
      content: form,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Информация об ученике", style: TextStyle(fontSize: 22)),
            IconButton(icon: const Icon(Icons.create), onPressed: () => _changeStudentInfo(context)),
          ],
        ),
        const SizedBox(height: 16),
        Consumer(
          builder: (context, ref, child) {
            final studentWithInfo = ref.watch(RootProvider.getStudentInfoProvider());

            final student = studentWithInfo.student;
            if (student != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SeparatedList(separatorBuilder: (_, __) => const Divider(), children: [
                      _studentInfoFormField("Фамилия", student.lastName),
                      _studentInfoFormField("Имя", student.name),
                      _studentInfoFormField("Дата рождения", student.birthDay != null ? DateFormat("dd.MM.yyyy").format(student.birthDay!) : "Не указано"),
                      _studentInfoFormField("Почта", student.email),
                      _studentInfoFormField("Телефон", student.phone ?? "Не указано"),
                      _studentInfoFormField("Уровень образования", student.education ?? "Не указано"),
                    ]),
                    const SizedBox(height: 20),
                    _studentInfoGetParents(student.parents, context),
                  ],
                ),
              );
            } else {
              return const Text("Произошла ошибка при загрузке данных. Попробуйте позже.");
            }
          },
        ),
      ],
    );
  }
}
