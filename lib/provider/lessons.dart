import 'package:flutter/foundation.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/lesson.dart';

class Lessons with ChangeNotifier {
  Lesson _lesson;

  Lessons(this._lesson);

  Lesson get lesson => _lesson;

  void setDescription(String newDescription) {
    _lesson.description = newDescription;
    updateDataOnServer();
    notifyListeners();
  }

  void setHometask(HomeTask newHomeTask) {
    _lesson.homeTask = newHomeTask;
    updateDataOnServer();
    notifyListeners();
  }

  Future<void> setJitsyLink() async {
    _lesson.jitsyLink =
        await Future<String>.delayed(Duration(milliseconds: 500), () => "");
    notifyListeners();
  }

  void updateDataOnServer() {
    // TODO: PUT lesson info to server
  }
}
