import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/root_provider.dart';

class AddingTeacherAccountScreen extends StatefulWidget {
  const AddingTeacherAccountScreen({Key? key}) : super(key: key);

  @override
  State<AddingTeacherAccountScreen> createState() => _AddingTeacherAccountScreenState();
}

class _AddingTeacherAccountScreenState extends State<AddingTeacherAccountScreen> {
  final GlobalKey<FormState> teacherFormKey = GlobalKey();
  final Teacher teacher = Teacher.empty();

  String? selectedValue;
  DateTime? pickedDate;
  final TextEditingController _dateController = TextEditingController();

  void _submit() {
    if (!teacherFormKey.currentState!.validate()) {
      return;
    }
    teacherFormKey.currentState!.save();
    RootProvider.getUsers().addTeacher(teacher);
    Navigator.of(context).pop();
  }

  Widget get _addingForm => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Введите данные преподавателя", style: TextStyle(fontSize: 22)),
            Form(
              key: teacherFormKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Фамилия", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Введите фамилию";
                      }
                      return null;
                    },
                    onSaved: (newValue) => teacher.lastName = newValue!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Имя", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Введите имя";
                      }
                      return null;
                    },
                    onSaved: (newValue) => teacher.name = newValue!,
                  ),
                  TextFormField(
                      decoration: const InputDecoration(labelText: "Отчество", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      keyboardType: TextInputType.name,
                      onSaved: (newValue) {
                        if (newValue != null) {
                          if (newValue.isNotEmpty) {
                            teacher.fatherName = newValue;
                            return;
                          }
                        }
                        teacher.fatherName = null;
                      }),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Дата рождения", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                    controller: _dateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () async {
                      DateTime? _pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (_pickedDate != null) {
                        String formattedDate = DateFormat('dd.MM.yyyy').format(_pickedDate);
                        _dateController.text = formattedDate;

                        setState(() {
                          pickedDate = _pickedDate;
                        });
                      } else {
                        debugPrint("Date is not selected");
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || pickedDate == null) {
                        return "Введите дату рождения";
                      }
                      return null;
                    },
                    onSaved: (newValue) => teacher.birthDay = pickedDate!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Почта", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains("@")) {
                        return "Введите почту";
                      }
                      return null;
                    },
                    onSaved: (newValue) => teacher.email = newValue!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Телефон", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Введите телефон";
                      }
                      return null;
                    },
                    onSaved: (newValue) => teacher.phone = newValue!,
                  ),
                  DropdownButtonFormField<String>(
                    hint: const Text("Образование"),
                    value: selectedValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Выберите полученное образование";
                      }
                      return null;
                    },
                    onSaved: (newValue) => teacher.education = newValue!,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(child: Text("Среднее"), value: "Среднее"),
                      DropdownMenuItem<String>(child: Text("Среднее профессиональное"), value: "Среднее профессиональное"),
                      DropdownMenuItem<String>(child: Text("Высшее"), value: "Высшее"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget get _saveTeacherAccountButton => ElevatedButton(
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
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(hasScrollBody: false, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [_addingForm]))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _saveTeacherAccountButton,
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
