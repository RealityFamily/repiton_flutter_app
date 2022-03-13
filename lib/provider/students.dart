import 'package:flutter/foundation.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/model/student.dart';

class Students with ChangeNotifier {
  late final String authToken;
  late final List<String> userRole;
  late List<Student> _students;

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

  Future<LearnStatistics> getStatistics(
    DateTime showDate,
    InfoVisualisationState state, [
    DateTime? customDateFrom,
    DateTime? customDateTo,
  ]) async {
    await Future.delayed(const Duration(milliseconds: 500));

    late DateTime dateFrom;
    late DateTime dateTo;

    switch (state) {
      case InfoVisualisationState.week:
        dateFrom = showDate.subtract(Duration(days: showDate.weekday - 1));
        dateTo = showDate
            .add(Duration(days: DateTime.daysPerWeek - showDate.weekday));
        break;
      case InfoVisualisationState.month:
        dateFrom = DateTime(showDate.year, showDate.month, 1);
        dateTo = DateTime(showDate.year, showDate.month + 1, 0);
        break;
      case InfoVisualisationState.custom:
        dateFrom = customDateFrom ?? DateTime(showDate.year, showDate.month, 1);
        dateTo =
            customDateFrom ?? DateTime(showDate.year, showDate.month + 1, 0);
        break;
    }

    return LearnStatistics(allHomeTasks: 5, allPresents: 7, disciplines: [
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
    ]);
  }
}
