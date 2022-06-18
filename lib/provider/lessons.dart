import 'package:flutter/foundation.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/lesson.dart';

class LessonsProvider with ChangeNotifier {
  Lesson? _lesson;

  Lesson? get lesson => _lesson;

  void setDescription(String newDescription) {
    if (_lesson == null) return;
    _lesson!.description = newDescription;
    // TODO: Call API method with new data of lesson https://backend.repiton.dev.realityfamily.ru:9046/swagger-ui/?urls.primaryName=discipline-lesson-service#/Lessons/putLessonId
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
    _lesson!.status = LessonStatus.started;
    // TODO: Refactor to API call https://backend.repiton.dev.realityfamily.ru:9046/swagger-ui/?urls.primaryName=discipline-lesson-service#/Lessons/getLessonIdStartLesson
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }

  void openLesson(Lesson newLesson) {
    _lesson = newLesson;
  }

  void closeLesson() {
    _lesson = null;
  }
}
