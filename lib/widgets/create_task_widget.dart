import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/remote_file.dart';
import 'package:repiton/widgets/remote_file_widget.dart';

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
  final List<RemoteFile> _files = [];
  final TextEditingController _taskDescription = TextEditingController();

  bool _descriptionVisibility = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      debugPrint(constraint.maxHeight.toString());
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
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
            Container(
              constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: (constraint.maxHeight - 354 > 100 ? constraint.maxHeight - 354 : 100),
              ),
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
                        hintText:
                            'Введите задание для ученика, которое он увидет перейдя во вкладку "Домашнее задание"',
                        hintMaxLines: 3,
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.add),
                  itemBuilder: (_) => ["Добавить фото...", "Добавить файл..."]
                      .map(
                        (item) => PopupMenuItem<String>(
                          value: item,
                          child: Row(
                            children: [
                              Icon(item.contains("фото") ? Icons.image : Icons.attach_file),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(item),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onSelected: (fileType) async {
                    setState(() {
                      _isLoading = true;
                    });

                    File? newFile;
                    if (fileType.contains("фото")) {
                      var result = await ImagePicker().pickImage(source: ImageSource.gallery);
                      newFile = result != null ? File(result.path) : null;
                    } else {
                      var result = await FilePicker.platform.pickFiles();
                      newFile = result != null ? File(result.files.single.path!) : null;
                    }

                    // TODO: Upload file for task
                    await Future.delayed(const Duration(milliseconds: 500));

                    setState(() {
                      // TODO: Written for test. Delete when network logic would be created
                      if (newFile != null) {
                        _files.add(RemoteFile(name: newFile.path.split("/").last));
                      }

                      _isLoading = false;
                    });
                  },
                ),
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
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => RemoteFileWidget(
                        file: _files[index],
                        renameFile: (newFileName) {
                          setState(() {
                            _files[index].name = newFileName + "." + _files[index].name.split(".").last;
                          });
                        },
                        deleteFile: (fileName) {
                          setState(() {
                            _files.remove(fileName);
                          });
                        },
                      ),
                      separatorBuilder: (context, index) => const VerticalDivider(
                        color: Colors.grey,
                        indent: 10,
                        endIndent: 10,
                      ),
                      itemCount: _files.length,
                    );
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
        ),
      );
    });
  }
}
