import 'package:flutter/foundation.dart';
import 'package:repiton/core/comparing/date_comparing.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/auth.dart';

class Students with ChangeNotifier {
  late final String authToken;
  late final List<Role> userRole;
  late List<Student> _students;

  LearnStatistics? _statistics;
  List<DisciplineLearnStatistics> _showingDisciplines = [];

  Students({
    required List<Student>? prevStudents,
    required this.authToken,
    required this.userRole,
  }) : _students = prevStudents ?? [];

  Students.empty() {
    _students = [
      Student(
        id: "s1",
        name: "Виталий",
        lastName: "Евпанько",
        birthDay: DateTime.now(),
        email: "",
        phone: "",
        imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
        education: "",
        parents: [],
        price: 0,
        hours: 0,
      ),
    ];
    authToken = "";
    userRole = [];
  }

  List<Student> get students {
    return [..._students];
  }

  LearnStatistics? get statictics {
    return _statistics;
  }

  List<DisciplineLearnStatistics> get showingDisciplines {
    return [..._showingDisciplines];
  }

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  Future<Student> findById(String id) async {
    if (_students.firstWhere((teacher) => teacher.id == id, orElse: () => Student.empty()).id != "") {
      return _students.firstWhere((teacher) => teacher.id == id);
    } else {
      return Student.empty();
    }
  }

  void fecthAndSetTeachersInfoForADay(DateTime day) {
    _showingDisciplines = [];
    if (_statistics == null) {
      return;
    }

    for (var discipline in _statistics!.disciplines) {
      for (var lesson in discipline.discipline.lessons) {
        if (lesson.dateTimeStart.isSameDate(day)) {
          _showingDisciplines.add(discipline);
        }
      }
    }
    notifyListeners();
  }

  void fecthAndSetTeachersInfoForAPeriod(DateTime startDay, DateTime endDay) {
    _showingDisciplines = [];
    if (_statistics == null) {
      return;
    }

    for (var discipline in _statistics!.disciplines) {
      for (var lesson in discipline.discipline.lessons) {
        if ((lesson.dateTimeStart.isAfter(startDay) || lesson.dateTimeStart.isSameDate(startDay)) &&
            (lesson.dateTimeStart.isBefore(endDay) || lesson.dateTimeStart.isSameDate(endDay))) {
          _showingDisciplines.add(discipline);
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchAndSetStatistics(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    _showingDisciplines = [];

    await Future.delayed(const Duration(milliseconds: 500));

    _statistics = LearnStatistics(
      allHomeTasks: 5,
      allPresents: 7,
      disciplines: [
        DisciplineLearnStatistics(
          discipline: Discipline(
            id: "d1",
            name: "Информатика",
            teacher: Teacher.empty()
              ..name = "Зинаида"
              ..lastName = "Юрьевна"
              ..fatherName = "Аркадьевна"
              ..imageUrl = "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
            student: Student.empty(),
            lessons: [
              Lesson(
                id: "l1",
                name: "Урок №1",
                description: "Какая-то инфа по уроку",
                status: LessonStatus.done,
                dateTimeStart: DateTime.now().subtract(const Duration(
                  days: 1,
                )),
                dateTimeEnd: DateTime.now().add(
                  const Duration(hours: 2),
                ),
              ),
              Lesson(
                id: "l2",
                name: "Урок №2",
                description: "Какая-то инфа по уроку",
                status: LessonStatus.canceled,
                dateTimeStart: DateTime.now().subtract(const Duration(days: 3)),
                dateTimeEnd: DateTime.now().add(
                  const Duration(hours: 2),
                ),
              ),
              Lesson(
                id: "l3",
                name: "Урок №3",
                description: "Какая-то инфа по уроку",
                status: LessonStatus.moved,
                dateTimeStart: DateTime.now(),
                dateTimeEnd: DateTime.now().add(
                  const Duration(hours: 2),
                ),
              ),
            ],
            rocketChatReference: "",
          ),
          presents: 7,
          homeTasks: 5,
        ),
      ],
    );

    notifyListeners();
  }
}
