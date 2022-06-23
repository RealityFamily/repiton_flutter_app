import 'package:flutter/foundation.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/repos/lesson_repo.dart';

class LessonsProvider with ChangeNotifier {
  Lesson? _lesson;
  final ILessonRepo _repo;

  LessonsProvider(this._repo);

  Lesson? get lesson => _lesson;

  void setDescription(String newDescription) async {
    if (_lesson == null) return;
    _lesson = await _repo.updateLessonInfo(_lesson!..description = newDescription);
    notifyListeners();
  }

  void setHometask(HomeTask newHomeTask) {
    if (_lesson == null) return;
    // TODO: Call API method https://backend.repiton.dev.realityfamily.ru:9046/swagger-ui/?urls.primaryName=discipline-lesson-service#/Lessons/postLessonIdHometask
    _lesson!.addHomeTaskToLesson(newHomeTask);
    notifyListeners();
  }

  Future<void> updateLessonInfo() async {
    if (_lesson == null) return;
    _lesson = await _repo.getLessonInfo(_lesson!.id);
    notifyListeners();
  }

  Future<void> startLesson() async {
    if (_lesson == null) return;
    _lesson = await _repo.startLesson(_lesson!.id);
    notifyListeners();
  }

  Future<void> endLesson() async {
    if (_lesson == null) return;
    _lesson = await _repo.endLesson(_lesson!.id);
    notifyListeners();
  }

  Future<void> openLesson(String lessonId) async {
    _lesson = await _repo.getLessonInfo(lessonId);
    notifyListeners();
  }

  LessonStatus? get lessonStatus => _lesson?.status;

  bool isActiveLessonBefore(Duration duration) {
    if (_lesson == null) return false;
    return _lesson!.dateTimeStart.isAfter(DateTime.now()) && _lesson!.dateTimeStart.isBefore(DateTime.now().subtract(duration));
  }

  void closeLesson() {
    _lesson = null;
  }
}
