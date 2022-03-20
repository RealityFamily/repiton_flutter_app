import 'package:repiton/model/test.dart';

class HomeTask {
  late String id;
  late String description;
  late String mark;
  late String markDescription;
  late HomeTaskType type;
  Test? test;
  late List<String> files;

  HomeTask({
    required this.id,
    required this.description,
    required this.mark,
    required this.markDescription,
    required this.type,
    this.test,
    required this.files,
  });

  HomeTask.empty() {
    id = "";
    description = "";
    mark = "";
    markDescription = "";
    type = HomeTaskType.task;
    test = null;
    files = [];
  }
}

enum HomeTaskType {
  test,
  task,
}
