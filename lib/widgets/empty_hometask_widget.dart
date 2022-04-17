import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/screens/teacher/create_hometask_screen.dart';

import '../provider/lessons.dart';

class EmptyHometaskWidget extends StatelessWidget {
  const EmptyHometaskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Домашнее задание",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        const Divider(
          color: Color(0xFFB4B4B4),
          thickness: 1,
        ),
        SizedBox(
          height: (MediaQuery.of(context).size.height - 450 > 150 ? MediaQuery.of(context).size.height - 450 : 150),
          child: Center(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                "Домашнее задание пока не задано",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFB4B4B4),
          thickness: 1,
        ),
        const SizedBox(
          height: 14,
        ),
        Consumer<Lessons>(
          builder: (context, lessons, _) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            onPressed: () async {
              HomeTask? _newHometask = await Navigator.of(context).push<HomeTask>(
                MaterialPageRoute(
                  builder: (context) => const CreateHometaskScreen(),
                ),
              );

              if (_newHometask == null) return;
              lessons.setHometask(_newHometask);
            },
            child: const Text(
              "Создать домашнее задание",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
