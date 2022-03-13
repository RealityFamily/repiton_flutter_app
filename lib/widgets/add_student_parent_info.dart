import 'package:flutter/material.dart';
import 'package:repiton/model/parent.dart';

class AddStudentParentInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey();

  final Parent result = Parent.empty();

  AddStudentParentInfo({Key? key}) : super(key: key);

  @override
  State<AddStudentParentInfo> createState() => _AddStudentParentInfoState();
}

class _AddStudentParentInfoState extends State<AddStudentParentInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
            ],
          ),
        ),
      ],
    );
  }
}
