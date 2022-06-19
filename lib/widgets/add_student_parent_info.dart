import 'package:flutter/material.dart';
import 'package:repiton/model/parent.dart';

// ignore: must_be_immutable
class AddStudentParentInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final String parentTitle;
  Function()? onDeleteButtonPressed;
  final Parent result = Parent.empty();

  AddStudentParentInfo({required this.parentTitle, this.onDeleteButtonPressed, Key? key}) : super(key: key);

  @override
  State<AddStudentParentInfo> createState() => _AddStudentParentInfoState();
}

class _AddStudentParentInfoState extends State<AddStudentParentInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.parentTitle, style: const TextStyle(fontWeight: FontWeight.bold))),
            if (widget.onDeleteButtonPressed != null) IconButton(onPressed: widget.onDeleteButtonPressed, icon: const Icon(Icons.delete, color: Colors.red)),
          ],
        ),
        Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Фамилия"),
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
                decoration: const InputDecoration(labelText: "Имя"),
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
                decoration: const InputDecoration(labelText: "Отчество"),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите отчество";
                  }
                  return null;
                },
                onSaved: (newValue) => widget.result.fatherName = newValue!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Телефон"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите телефон";
                  }
                  return null;
                },
                onSaved: (newValue) => widget.result.phone = newValue!,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
