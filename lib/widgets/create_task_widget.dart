import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:repiton/model/home_task.dart';

class CreateTaskWidget extends StatefulWidget {
  final Function(HomeTask) callBack;

  const CreateTaskWidget({
    required this.callBack,
    Key? key,
  }) : super(key: key);

  @override
  State<CreateTaskWidget> createState() => _CreateTaskWidgetState();
}

class _CreateTaskWidgetState extends State<CreateTaskWidget> {
  final List<String> _files = [];
  final TextEditingController _taskDescription = TextEditingController();

  bool _descriptionVisibility = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Описание задания",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _descriptionVisibility = !_descriptionVisibility;
                });
              },
              icon: Icon(_descriptionVisibility ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
            )
          ],
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: _descriptionVisibility
                ? Markdown(
                    data: _taskDescription.text,
                    padding: EdgeInsets.zero,
                  )
                : TextField(
                    controller: _taskDescription,
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Введите задание для ученика, которое он увидет перейдя во вкладку "Домашнее задание"',
                      hintMaxLines: 3,
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                "Файлы к заданию",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                // TODO: Upload file for task
                await Future.delayed(const Duration(milliseconds: 500));

                setState(() {
                  _isLoading = false;
                });
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        SizedBox(
          height: 200,
          child: (() {
            if (!_isLoading) {
              if (_files.isEmpty) {
                return const Center(
                  child: Text("Пока не прикреплено ни одного файла"),
                );
              } else {
                return Wrap();
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }()),
        ),
        ElevatedButton(
          onPressed: () {
            if (_taskDescription.text.isEmpty) return;
            widget.callBack(
              HomeTask(
                id: "h_1",
                description: _taskDescription.text,
                type: HomeTaskType.task,
                files: _files,
              ),
            );
          },
          child: const Text("Создать задание"),
        )
      ],
    );
  }
}
