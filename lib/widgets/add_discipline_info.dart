import 'package:flutter/material.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/repos/admin_repo.dart';

class AddDisciplineInfo extends StatefulWidget {
  final Function(Discipline) result;
  final Teacher? initTeacher;
  final GlobalKey<FormState> formKey;

  const AddDisciplineInfo({required this.result, required this.formKey, this.initTeacher, Key? key}) : super(key: key);

  @override
  State<AddDisciplineInfo> createState() => _AddDisciplineInfoState();
}

class _AddDisciplineInfoState extends State<AddDisciplineInfo> {
  Discipline newDiscipline = Discipline.empty();
  Teacher? selectedValue;
  List<Teacher> teachersForSelect = [];
  bool isLoading = false;

  Future<List<Teacher>> get _getTeachersForSelecting {
    if (widget.initTeacher != null) {
      return Future.microtask(() => [widget.initTeacher!]);
    } else {
      return AdminRepo().getTeachers();
    }
  }

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
              return "Выберите ведущего преподавателя";
            }
            return null;
          },
          onSaved: (newValue) => newDiscipline.teacher = newValue!,
          onChanged: widget.initTeacher != null ? null : (value) => setState(() => selectedValue = value!),
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
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const Text("Информация о проведении занятий", style: TextStyle(fontSize: 22)),
          TextFormField(
            decoration: const InputDecoration(labelText: "Название дисциплины", contentPadding: EdgeInsets.symmetric(vertical: 5)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Введите название дисциплины";
              }
              return null;
            },
            onSaved: (newValue) => newDiscipline.name = newValue!,
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
            onSaved: (newValue) => newDiscipline.price = double.parse(newValue!),
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
            onSaved: (newValue) => newDiscipline.minutes = int.parse(newValue!),
          ),
          FormField(
            builder: (field) => Container(),
            onSaved: (_) => widget.result(newDiscipline),
          ),
        ],
      ),
    );
  }
}
