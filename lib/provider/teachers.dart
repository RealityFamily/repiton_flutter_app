import 'package:flutter/foundation.dart';
import 'package:repiton/core/comparing/date_comparing.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/auth.dart';

class Teachers with ChangeNotifier {
  late final String authToken;
  late final List<Role> userRole;
  late List<Teacher> _teachers;

  FinancialStatistics? _statistics;
  List<StudentFinancialStatistics> _students = [];

  List<Discipline> _disciplines = [];
  List<Discipline> _todayLessons = [];

  List<Teacher> get teachers {
    return [..._teachers];
  }

  FinancialStatistics? get statictics {
    return _statistics;
  }

  List<StudentFinancialStatistics> get students {
    return [..._students];
  }

  List<Discipline> get disciplines {
    return [..._disciplines];
  }

  List<Discipline> get todayLessons {
    return [..._todayLessons];
  }

  Teachers.empty() {
    _teachers = [
      Teacher(
        id: "t1",
        name: "Зинаида",
        lastName: "Юрьевна",
        fatherName: "Аркадьевна",
        birthDay: DateTime.now(),
        email: "",
        phone: "",
        imageUrl: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
        education: "",
      ),
    ];
    userRole = [];
    authToken = "";
  }

  Teachers({
    required this.authToken,
    required this.userRole,
    required List<Teacher> prevTeachers,
  }) : _teachers = prevTeachers;

  void addTeacher(Teacher teacher) {
    _teachers.add(teacher);
    notifyListeners();
  }

  Future<Teacher> findById(String id) async {
    if (_teachers.firstWhere((teacher) => teacher.id == id, orElse: () => Teacher.empty()).id != "") {
      return _teachers.firstWhere((teacher) => teacher.id == id);
    } else {
      return Teacher.empty();
    }
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

    //TODO: Send request to server

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
              status: LessonStatus.canceled,
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

  Future<void> fetchAndSetLessons(DateTime showDate) async {
    await Future.delayed(const Duration(milliseconds: 500));

    DateTime dateFrom = DateTime(showDate.year, showDate.month, 1);
    DateTime dateTo = DateTime(showDate.year, showDate.month + 1, 0);

    _disciplines = [
      Discipline(
          id: "d1",
          name: "Информатика",
          teacher: Teacher.empty(),
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
          rocketChatReference: "")
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
