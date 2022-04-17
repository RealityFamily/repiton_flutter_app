import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/lessons.dart';
import 'package:repiton/widgets/remote_file_widget.dart';

class TaskInfoWidget extends StatelessWidget {
  const TaskInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Lessons>(
      builder: (context, lessons, _) => Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Описание задания",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const Divider(
            color: Color(0xFFB4B4B4),
            thickness: 1,
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.height - 450 > 150 ? MediaQuery.of(context).size.height - 603 : 150),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                width: double.infinity,
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Text(
                    lessons.lesson!.homeTask!.description,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Прикрепленные файлы",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const Divider(
            color: Color(0xFFB4B4B4),
            thickness: 1,
          ),
          SizedBox(
            height: 100,
            child: (() {
              if (lessons.lesson!.homeTask!.files.isEmpty) {
                return const Center(
                  child: Text("Нет прикрепленых файлов"),
                );
              } else {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => RemoteFileWidget(
                    file: lessons.lesson!.homeTask!.files[index],
                    height: 100,
                  ),
                  separatorBuilder: (context, index) => const VerticalDivider(
                    color: Colors.grey,
                    indent: 10,
                    endIndent: 10,
                  ),
                  itemCount: lessons.lesson!.homeTask!.files.length,
                );
              }
            }()),
          ),
          const Divider(
            color: Color(0xFFB4B4B4),
            thickness: 1,
          ),
          const SizedBox(
            height: 14,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            onPressed: lessons.lesson!.homeTask!.isUncheckedAnswers() ? () {} : null,
            child: const Text(
              "Проверить домашнее задание",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
