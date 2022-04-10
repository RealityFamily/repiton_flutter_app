import 'package:flutter/material.dart';

class CreateTaskWidget extends StatelessWidget {
  const CreateTaskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text("Описание задания"),
        ),
        Expanded(
          child: Form(
            child: TextFormField(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Text("Описание задания"),
        ),
        Expanded(
          child: Form(
            child: TextFormField(),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Создать задание"),
        )
      ],
    );
  }
}
