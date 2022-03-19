class Lesson {
  late LessonStatus status;
  late DateTime dateTimeStart;
  late DateTime dateTimeEnd;

  Lesson({
    required this.status,
    required this.dateTimeStart,
    required this.dateTimeEnd,
  });

  Lesson.empty() {
    status = LessonStatus.done;
    dateTimeStart = DateTime.now();
    dateTimeEnd = DateTime.now();
  }
}

enum LessonStatus {
  done,
  canceled,
  moved,
  planned,
}
