import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/teacher.dart';

class AddTeacherInfo extends StatefulWidget {
  final Teacher result;
  final GlobalKey<FormState> formKey;

  const AddTeacherInfo({
    required this.formKey,
    required this.result,
    Key? key,
  }) : super(key: key);

  @override
  State<AddTeacherInfo> createState() => _AddTeacherInfoState();
}

class _AddTeacherInfoState extends State<AddTeacherInfo> {
  String? selectedValue;
  DateTime? pickedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Введите данные преподавателя",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Фамилия",
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите фамилию";
                  }
                },
                onSaved: (newValue) {
                  widget.result.lastName = newValue!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Имя",
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите имя";
                  }
                },
                onSaved: (newValue) {
                  widget.result.name = newValue!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Отчество",
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите отчество";
                  }
                },
                onSaved: (newValue) {
                  widget.result.fatherName = newValue!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Дата рождения",
                ),
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
                    String formattedDate =
                        DateFormat('dd.MM.yyyy').format(_pickedDate);
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
                },
                onSaved: (newValue) {
                  widget.result.birthDay = pickedDate!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Почта",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Введите почту";
                  }
                },
                onSaved: (newValue) {
                  widget.result.email = newValue!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Телефон",
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите телефон";
                  }
                },
                onSaved: (newValue) {
                  widget.result.phone = newValue!;
                },
              ),
              DropdownButtonFormField<String>(
                hint: const Text("Образование"),
                value: selectedValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Выберите полученное образование";
                  }
                },
                onSaved: (newValue) {
                  widget.result.education = newValue!;
                },
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                      child: Text("Среднее"), value: "Среднее"),
                  DropdownMenuItem<String>(
                      child: Text("Среднее профессиональное"),
                      value: "Среднее профессиональное"),
                  DropdownMenuItem<String>(
                      child: Text("Высшее"), value: "Высшее"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
