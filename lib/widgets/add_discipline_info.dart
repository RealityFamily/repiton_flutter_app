import 'package:flutter/material.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/repos/teacher_repo.dart';

class AddDisciplineInfo extends StatefulWidget {
  final Discipline result;
  final String? initTeacherId;
  final GlobalKey<FormState> formKey;

  const AddDisciplineInfo({required this.result, required this.formKey, this.initTeacherId, Key? key}) : super(key: key);

  @override
  State<AddDisciplineInfo> createState() => _AddDisciplineInfoState();
}

class _AddDisciplineInfoState extends State<AddDisciplineInfo> {
  Teacher? selectedValue;
  List<Teacher> teachersForSelect = [];
  bool isLoading = false;

  Future<List<Teacher>> get _getTeachersForSelecting => TeacherRepo().getTeachersForSelecting(certainTeacherId: widget.initTeacherId);

  Widget get _teacherChooser {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (teachersForSelect.isNotEmpty) {
        return DropdownButtonFormField<Teacher>(
          hint: const Text("Выберите ведущего преподавателя"),
          value: selectedValue,
          validator: (value) {
            if (value == null) {
              return "Выберите ведущего образпреподавателяование";
            }
            return null;
          },
          onSaved: (newValue) => widget.result.teacher = newValue!,
          onChanged: widget.initTeacherId != null ? null : (value) => setState(() => selectedValue = value!),
          items: teachersForSelect.map((teacher) => DropdownMenuItem<Teacher>(child: Text(teacher.fullName), value: teacher)).toList(),
        );
      } else {
        return const Text("Произошла ошибка при получении данных преподавателей");
      }
    }
  }

  void _getTeachersForShow() async {
    setState(() => isLoading = true);
    final result = await _getTeachersForSelecting;
    setState(() {
      isLoading = false;
      teachersForSelect = result;
      if (result.isNotEmpty && result.length == 1) selectedValue = result.first;
    });
  }

  @override
  void initState() {
    _getTeachersForShow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Информация о проведении занятий", style: TextStyle(fontSize: 22)),
        TextFormField(
          decoration: const InputDecoration(labelText: "Название дисциплины", contentPadding: EdgeInsets.symmetric(vertical: 5)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Введите ставку";
            }
            return null;
          },
          onSaved: (newValue) => widget.result.name = newValue!,
        ),
        const SizedBox(
          width: 23,
        ),
        _teacherChooser,
        const SizedBox(
          width: 23,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Ставка", suffixText: "₽ в час", contentPadding: EdgeInsets.symmetric(vertical: 5)),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty || double.tryParse(value) == null) {
              return "Введите ставку";
            }
            return null;
          },
          onSaved: (newValue) => widget.result.price = double.parse(newValue!),
        ),
        const SizedBox(
          width: 23,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Количество занятий", suffixText: "ч. в нед.", contentPadding: EdgeInsets.symmetric(vertical: 5)),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty || int.tryParse(value) == null) {
              return "Введите количество занятий";
            }
            return null;
          },
          onSaved: (newValue) => widget.result.minutes = int.parse(newValue!),
        ),
      ],
    );
  }
}
