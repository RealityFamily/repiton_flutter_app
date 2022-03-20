import 'package:repiton/model/home_task.dart';

class Lesson {
  late String id;
  late String name;
  late String description;
  late LessonStatus status;
  late DateTime dateTimeStart;
  late DateTime dateTimeEnd;
  HomeTask? homeTask;

  Lesson({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    this.homeTask,
  });

  Lesson.empty() {
    id = "";
    name = "";
    description = "";
    status = LessonStatus.planned;
    dateTimeStart = DateTime.now();
    dateTimeEnd = DateTime.now();
    homeTask = null;
  }
}

enum LessonStatus {
  done,
  canceled,
  moved,
  planned,
}
