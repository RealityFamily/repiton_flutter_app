import 'package:repiton/model/home_task_answer.dart';
import 'package:repiton/model/remote_file.dart';
import 'package:repiton/model/test.dart';

class HomeTask {
  String? id;
  late String description;
  late HomeTaskType type;
  Test? test;
  late List<RemoteFile> files;
  late List<HomeTaskAnswer> answers = [];

  HomeTask({
    this.id,
    required this.description,
    required this.type,
    this.test,
    required this.files,
    List<HomeTaskAnswer>? answers,
  }) : answers = answers ?? [];

  HomeTask.empty() {
    id = null;
    description = "";
    type = HomeTaskType.task;
    test = null;
    files = [];
    answers = [];
  }

  bool isUncheckedAnswers() {
    if (answers.isEmpty) return false;
    for (var answer in answers) {
      if (answer.homeTaskMark == null) return true;
    }
    return false;
  }

  static HomeTaskType stringToHomeTaskType(String type) {
    if (type == "Test") {
      return HomeTaskType.test;
    } else if (type == "Task") {
      return HomeTaskType.task;
    } else {
      throw Exception("Error in parsing HomeTaskType. Got $type, which not in HomeTaskType values");
    }
  }
}

enum HomeTaskType {
  test,
  task,
}
