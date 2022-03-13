import 'package:flutter/foundation.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/model/teacher.dart';

class Teachers with ChangeNotifier {
  late final String authToken;
  late final List<String> userRole;
  late List<Teacher> _teachers;

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
        imageUrl:
            "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
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

  List<Teacher> get teachers {
    return [..._teachers];
  }

  void addTeacher(Teacher teacher) {
    _teachers.add(teacher);
    notifyListeners();
  }

  Future<Teacher> findById(String id) async {
    if (_teachers
            .firstWhere((teacher) => teacher.id == id,
                orElse: () => Teacher.empty())
            .id !=
        "") {
      return _teachers.firstWhere((teacher) => teacher.id == id);
    } else {
      return Teacher.empty();
    }
  }

  Future<FinancialStatistics> getStatistics(
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

    return FinancialStatistics(allLessons: 10, allPrice: 15000, students: [
      StudentFinancialStatistics(
        studentId: "s1",
        studentName: "Виталий",
        studentLastName: "Евпанько",
        studentImageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
        presents: 10,
        price: 15000,
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
