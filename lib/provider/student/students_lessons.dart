import 'package:flutter/foundation.dart';
import 'package:repiton/core/comparing/date_comparing.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/repos/student_repo.dart';

class StudentLessonsProvider with ChangeNotifier {
  List<Discipline> _disciplines = [];
  List<Discipline> _todayLessons = [];
  final IStudentRepo _repo;

  StudentLessonsProvider(this._repo);

  List<Discipline> get disciplines {
    return [..._disciplines];
  }

  List<Discipline> get todayLessons {
    return [..._todayLessons];
  }

  Future<void> fetchAndSetLessons(DateTime showDate) async {
    DateTime dateFrom = DateTime(showDate.year, showDate.month, 1);
    DateTime dateTo = DateTime(showDate.year, showDate.month + 1, 0);
    _todayLessons = [];

    _disciplines = await _repo.getTimetable(RootProvider.getAuth().id, dateFrom, dateTo);
    notifyListeners();
  }

  void fecthAndSetLessonsForADay(DateTime day) {
    _todayLessons = [];

    for (var discipline in _disciplines) {
      for (var lesson in discipline.lessons) {
        if (lesson.dateTimeStart.isSameDate(day)) {
          var tempDiscipline = discipline..lessons = discipline.lessons.where((lesson) => lesson.dateTimeStart.isSameDate(day)).toList();
          _todayLessons.add(tempDiscipline);
          break;
        }
      }
    }
    notifyListeners();
  }
}
