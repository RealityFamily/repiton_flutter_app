import 'package:flutter/foundation.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/lesson.dart';

class LessonsProvider with ChangeNotifier {
  Lesson? _lesson;

  Lesson? get lesson => _lesson;

  void setDescription(String newDescription) {
    if (_lesson == null) return;
    _lesson!.description = newDescription;
    updateDataOnServer();
    notifyListeners();
  }

  void setHometask(HomeTask newHomeTask) {
    if (_lesson == null) return;
    _lesson!.homeTask = newHomeTask;
    updateDataOnServer();
    notifyListeners();
  }

  Future<void> setJitsyLink() async {
    if (_lesson == null) return;
    _lesson!.jitsyLink = await Future<String>.delayed(const Duration(milliseconds: 500), () => "");
    notifyListeners();
  }

  void updateDataOnServer() {
    // TODO: PUT lesson info to server
  }

  void openLesson(Lesson newLesson) {
    _lesson = newLesson;
  }

  void closeLesson() {
    _lesson = null;
  }
}
