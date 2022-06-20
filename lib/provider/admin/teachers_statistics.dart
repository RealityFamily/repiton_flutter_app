import 'package:flutter/foundation.dart';
import 'package:repiton/core/comparing/date_comparing.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';

class TearchersStatiscticsProvider with ChangeNotifier {
  Teacher? _teacher;
  FinancialStatistics? _statistics;
  List<StudentFinancialStatistics> _students = [];

  Teacher get teacher => _teacher ?? Teacher.empty();
  set teacher(Teacher value) => _teacher = value;

  FinancialStatistics? get statictics {
    return _statistics;
  }

  List<StudentFinancialStatistics> get students {
    return [..._students];
  }

  void fecthAndSetStudentsInfoForADay(DateTime day) {
    _students = [];
    if (_statistics == null) {
      return;
    }

    for (var student in _statistics!.students) {
      for (var lesson in student.lessons) {
        if (lesson.dateTimeStart.isSameDate(day)) {
          _students.add(student);
        }
      }
    }
    notifyListeners();
  }

  Future<void> fecthAndSetStudentsInfoForAPeriod(DateTime startDay, DateTime endDay) async {
    _students = [];
    if (_statistics == null) {
      return;
    }

    for (var student in _statistics!.students) {
      for (var lesson in student.lessons) {
        if ((lesson.dateTimeStart.isAfter(startDay) || lesson.dateTimeStart.isSameDate(startDay)) &&
            (lesson.dateTimeStart.isBefore(endDay) || lesson.dateTimeStart.isSameDate(endDay))) {
          _students.add(student);
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchAndSetStatistics(
    DateTime dateFrom,
    DateTime dateTo,
  ) async {
    _students = [];

    await Future.delayed(const Duration(milliseconds: 500));

    //TODO: Call API method

    _statistics = FinancialStatistics(
      allLessons: 10,
      allPrice: 15000,
      students: [
        StudentFinancialStatistics(
          student: Student.empty()
            ..id = "s1"
            ..name = "Виталий"
            ..lastName = "Евпанько"
            ..imageUrl = "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
          presents: 10,
          price: 15000,
          lessons: [
            Lesson(
              id: "l1",
              name: "Урок №1",
              description: "Какая-то инфа по уроку",
              status: LessonStatus.done,
              dateTimeStart: DateTime.now().subtract(
                const Duration(days: 35),
              ),
              dateTimeEnd: DateTime.now().add(
                const Duration(hours: 2),
              ),
            ),
            Lesson(
              id: "l2",
              name: "Урок №2",
              description: "Какая-то инфа по уроку",
              status: LessonStatus.canceledByStudent,
              dateTimeStart: DateTime.now().subtract(
                const Duration(days: 8),
              ),
              dateTimeEnd: DateTime.now(),
            ),
            Lesson(
              id: "l3",
              name: "Урок №3",
              description: "Какая-то инфа по уроку",
              status: LessonStatus.moved,
              dateTimeStart: DateTime.now().subtract(
                const Duration(days: 4),
              ),
              dateTimeEnd: DateTime.now().add(
                const Duration(hours: 2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
