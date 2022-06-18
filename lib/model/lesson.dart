import 'package:repiton/model/home_task.dart';

class Lesson {
  late String id;
  late String name;
  late String description;
  late LessonStatus status;
  late DateTime dateTimeStart;
  late DateTime dateTimeEnd;
  List<HomeTask>? _homeTask;

  Lesson({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    List<HomeTask>? homeTask,
  }) : _homeTask = homeTask;

  Lesson.empty() {
    id = "";
    name = "";
    description = "";
    status = LessonStatus.planned;
    dateTimeStart = DateTime.now();
    dateTimeEnd = DateTime.now();
    _homeTask = null;
  }

  void addHomeTaskToLesson(HomeTask homeTask) {
    _homeTask ??= [];
    _homeTask!.add(homeTask);
  }

  static LessonStatus stringToLessonStatus(String status) {
    if (status == "PLANNED") {
      return LessonStatus.planned;
    } else if (status == "STARTED") {
      return LessonStatus.started;
    } else if (status == "DONE") {
      return LessonStatus.done;
    } else if (status == "MOVED") {
      return LessonStatus.moved;
    } else if (status == "CANCELED_BY_TEACHER") {
      return LessonStatus.canceledByTeacher;
    } else if (status == "CANCELED_BY_STUDENT") {
      return LessonStatus.canceledByStudent;
    } else {
      throw Exception("Error in parsing LessonStatus. Got $status, which not in LessonStatus values");
    }
  }

  HomeTask? get homeTask => _homeTask?.last;
}

enum LessonStatus {
  planned,
  started,
  done,
  moved,
  canceledByTeacher,
  canceledByStudent,
}
