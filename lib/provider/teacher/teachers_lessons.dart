import 'package:flutter/foundation.dart';
import 'package:repiton/core/comparing/date_comparing.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';

class TeachersLessonsProvider with ChangeNotifier {
  List<Discipline> _disciplines = [];
  List<Discipline> _todayLessons = [];

  List<Discipline> get disciplines {
    return [..._disciplines];
  }

  List<Discipline> get todayLessons {
    return [..._todayLessons];
  }

  Future<void> fetchAndSetLessons(DateTime showDate) async {
    await Future.delayed(const Duration(milliseconds: 500));

    DateTime dateFrom = DateTime(showDate.year, showDate.month, 1);
    DateTime dateTo = DateTime(showDate.year, showDate.month + 1, 0);

    // TODO: Call API method https://backend.repiton.dev.realityfamily.ru:9046/swagger-ui/?urls.primaryName=discipline-lesson-service#/Timetable/getTeacherIdTimetable

    _disciplines = [
      Discipline(
        id: "d1",
        name: "Информатика",
        teacher: Teacher.empty()
          ..id = "t1"
          ..name = "Зинаида"
          ..lastName = "Юрьевна"
          ..fatherName = "Аркадьевна"
          ..birthDay = DateTime.now()
          ..imageUrl = "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
        student: Student.empty()
          ..id = "s1"
          ..name = "Виталий"
          ..lastName = "Евпанько"
          ..imageUrl = "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
        lessons: [
          Lesson(
            id: "l4",
            name: "Урок №4",
            description: "Какая-то инфа по уроку",
            status: LessonStatus.planned,
            dateTimeStart: DateTime.now(),
            dateTimeEnd: DateTime.now(),
          ),
          Lesson(
            id: "l5",
            name: "Урок №5",
            description: "Какая-то инфа по уроку",
            status: LessonStatus.done,
            dateTimeStart: DateTime.now().subtract(const Duration(hours: 4)),
            dateTimeEnd: DateTime.now(),
          ),
        ],
        rocketChatReference: [],
        minutes: 45,
        price: 1000,
      )
    ];
    notifyListeners();
  }

  void fecthAndSetLessonsForADay(DateTime day) {
    _todayLessons = [];
    if (_disciplines.isEmpty) {
      return;
    }

    for (var discipline in _disciplines) {
      for (var lesson in discipline.lessons) {
        if (lesson.dateTimeStart.isSameDate(day)) {
          var tempDiscipline = discipline
            ..lessons = discipline.lessons.where((lesson) => lesson.dateTimeStart.isSameDate(day)).toList();
          _todayLessons.add(tempDiscipline);
          break;
        }
      }
    }
    notifyListeners();
  }
}
