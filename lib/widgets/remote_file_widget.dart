import 'package:flutter/material.dart';
import 'package:repiton/model/remote_file.dart';

class RemoteFileWidget extends StatelessWidget {
  final RemoteFile file;
  final Function(RemoteFile) deleteFile;
  final Function(String) renameFile;

  const RemoteFileWidget({required this.file, required this.deleteFile, required this.renameFile, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String? result = await showDialog(
          context: context,
          builder: (ctx) {
            TextEditingController _newFileName = TextEditingController();
            return AlertDialog(
              title: const Text("Переименовать файл"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Введите новое название файла"),
                  TextField(
                    controller: _newFileName,
                    decoration: const InputDecoration(hintText: "Новое название файла..."),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("ОТМЕНА"),
                ),
                TextButton(
                  onPressed: () {
                    if (_newFileName.text.isEmpty) return;
                    Navigator.of(ctx).pop(_newFileName.text);
                  },
                  child: const Text("ОК"),
                ),
              ],
            );
          },
        );

        if (result == null) return;
        renameFile(result);
      },
      onLongPress: () async {
        bool result = await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Удалить файл?"),
                content:
                    Text("Вы действительно хотите удалить файл ${file.name} из прилогаемых к этому домашнему заданию?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("ОТМЕНА"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text("ОК"),
                  ),
                ],
              ),
            ) ??
            false;

        if (result) {
          deleteFile(file);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(
          maxWidth: 200,
          maxHeight: 80,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              file.name,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
