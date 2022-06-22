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
    _lesson = await _repo.updateLesson(_lesson!..description = newDescription);
    notifyListeners();
  }

  void setHometask(HomeTask newHomeTask) {
    if (_lesson == null) return;
    // TODO: Call API method https://backend.repiton.dev.realityfamily.ru:9046/swagger-ui/?urls.primaryName=discipline-lesson-service#/Lessons/postLessonIdHometask
    _lesson!.addHomeTaskToLesson(newHomeTask);
    notifyListeners();
  }

  Future<void> startLesson() async {
    if (_lesson == null) return;
    await _repo.startLesson(_lesson!.id);
    _lesson!.status = LessonStatus.started;
    notifyListeners();
  }

  Future<void> endLesson() async {
    if (_lesson == null) return;
    await _repo.endLesson(_lesson!.id);
    _lesson!.status = LessonStatus.done;
    notifyListeners();
  }

  void openLesson(Lesson newLesson) {
    _lesson = newLesson;
  }

  void closeLesson() {
    _lesson = null;
  }
}
