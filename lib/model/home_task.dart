import 'package:repiton/model/remote_file.dart';
import 'package:repiton/model/test.dart';

class HomeTask {
  late String? id;
  late String description;
  late String? mark;
  late String? markDescription;
  late HomeTaskType type;
  Test? test;
  late List<RemoteFile> files;

  HomeTask({
    this.id,
    required this.description,
    this.mark,
    this.markDescription,
    required this.type,
    this.test,
    required this.files,
  });

  HomeTask.empty() {
    id = null;
    description = "";
    mark = null;
    markDescription = null;
    type = HomeTaskType.task;
    test = null;
    files = [];
  }
}

enum HomeTaskType {
  test,
  task,
}
