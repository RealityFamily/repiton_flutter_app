import 'package:flutter/foundation.dart';
import 'package:repiton/core/comparing/date_comparing.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/model/student.dart';

class Students with ChangeNotifier {
  late final String authToken;
  late final List<String> userRole;
  late List<Student> _students;

  LearnStatistics? _statistics;
  List<StudentLearnStatistics> _disciplines = [];

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
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
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

  List<StudentLearnStatistics> get disciplines {
    return [..._disciplines];
  }

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  Future<Student> findById(String id) async {
    if (_students
            .firstWhere((teacher) => teacher.id == id,
                orElse: () => Student.empty())
            .id !=
        "") {
      return _students.firstWhere((teacher) => teacher.id == id);
    } else {
      return Student.empty();
    }
  }

  void fecthAndSetTeachersInfoForADay(DateTime day) {
    _disciplines = [];
    if (_statistics == null) {
      return;
    }

    for (var discipline in _statistics!.disciplines) {
      for (var lesson in discipline.lessons) {
        if (lesson.dateTimeStart.isSameDate(day)) {
          _disciplines.add(discipline);
        }
      }
    }
    notifyListeners();
  }

  void fecthAndSetTeachersInfoForAPeriod(DateTime startDay, DateTime endDay) {
    _disciplines = [];
    if (_statistics == null) {
      return;
    }

    for (var discipline in _statistics!.disciplines) {
      for (var lesson in discipline.lessons) {
        if ((lesson.dateTimeStart.isAfter(startDay) ||
                lesson.dateTimeStart.isSameDate(startDay)) &&
            (lesson.dateTimeStart.isBefore(endDay) ||
                lesson.dateTimeStart.isSameDate(endDay))) {
          _disciplines.add(discipline);
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchAndSetStatistics(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    _disciplines = [];

    await Future.delayed(const Duration(milliseconds: 500));

    _statistics = LearnStatistics(
      allHomeTasks: 5,
      allPresents: 7,
      disciplines: [
        StudentLearnStatistics(
          teacherId: "t1",
          teacherName: "Зинаида",
          teacherLastName: "Юрьевна",
          teacherFatherName: "Аркадьевна",
          disciplineId: "d1",
          disciplineName: "Информатика",
          teacherImageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
          presents: 7,
          homeTasks: 5,
          lessons: [
            Lesson(
              status: LessonStatus.done,
              dateTimeStart: DateTime.now(),
              dateTimeEnd: DateTime.now().add(
                const Duration(hours: 2),
              ),
            ),
            Lesson(
              status: LessonStatus.canceled,
              dateTimeStart: DateTime.now(),
              dateTimeEnd: DateTime.now().add(
                const Duration(hours: 2),
              ),
            ),
            Lesson(
              status: LessonStatus.moved,
              dateTimeStart: DateTime.now(),
              dateTimeEnd: DateTime.now().add(
                const Duration(hours: 2),
              ),
            ),
          ],
        ),
      ],
    );

    notifyListeners();
  }
}
