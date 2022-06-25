import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/student.dart';

class AddStudentInfo extends StatefulWidget {
  final Student result;
  final GlobalKey<FormState> formKey;
  final bool isTitleNeeded;

  const AddStudentInfo({
    required this.formKey,
    required this.result,
    this.isTitleNeeded = true,
    Key? key,
  }) : super(key: key);

  @override
  State<AddStudentInfo> createState() => _AddStudentInfoState();
}

class _AddStudentInfoState extends State<AddStudentInfo> {
  String? selectedValue;
  DateTime? pickedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    selectedValue = widget.result.education;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isTitleNeeded) const Text("Введите данные ученика", style: TextStyle(fontSize: 22)),
        Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.result.lastName,
                decoration: const InputDecoration(labelText: "Фамилия", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите фамилию";
                  }
                  return null;
                },
                onSaved: (newValue) => widget.result.lastName = newValue!,
              ),
              TextFormField(
                initialValue: widget.result.name,
                decoration: const InputDecoration(labelText: "Имя", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите имя";
                  }
                  return null;
                },
                onSaved: (newValue) => widget.result.name = newValue!,
              ),
              TextFormField(
                initialValue: widget.result.birthDay != null ? DateFormat('dd.MM.yyyy').format(widget.result.birthDay!) : null,
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

                    setState(() => pickedDate = _pickedDate);
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
                onSaved: (newValue) => widget.result.birthDay = pickedDate!,
              ),
              TextFormField(
                initialValue: widget.result.email,
                decoration: const InputDecoration(labelText: "Почта", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Введите почту";
                  }
                  return null;
                },
                onSaved: (newValue) => widget.result.email = newValue!,
              ),
              TextFormField(
                initialValue: widget.result.phone,
                decoration: const InputDecoration(labelText: "Телефон", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите телефон";
                  }
                  return null;
                },
                onSaved: (newValue) => widget.result.phone = newValue!,
              ),
              DropdownButtonFormField<String>(
                hint: const Text("В каком вы классе?"),
                value: selectedValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Выберите полученное образование";
                  }
                  return null;
                },
                onSaved: (newValue) => widget.result.education = newValue!,
                onChanged: (value) => setState(() => selectedValue = value!),
                items: const [
                  DropdownMenuItem<String>(child: Text("Дошкольник"), value: "Дошкольник"),
                  DropdownMenuItem<String>(child: Text("1"), value: "1"),
                  DropdownMenuItem<String>(child: Text("2"), value: "2"),
                  DropdownMenuItem<String>(child: Text("3"), value: "3"),
                  DropdownMenuItem<String>(child: Text("4"), value: "4"),
                  DropdownMenuItem<String>(child: Text("5"), value: "5"),
                  DropdownMenuItem<String>(child: Text("6"), value: "6"),
                  DropdownMenuItem<String>(child: Text("7"), value: "7"),
                  DropdownMenuItem<String>(child: Text("8"), value: "8"),
                  DropdownMenuItem<String>(child: Text("9"), value: "9"),
                  DropdownMenuItem<String>(child: Text("10"), value: "10"),
                  DropdownMenuItem<String>(child: Text("11"), value: "11"),
                  DropdownMenuItem<String>(child: Text("Студент"), value: "Студент"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
