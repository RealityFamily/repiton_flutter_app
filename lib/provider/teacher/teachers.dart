import 'package:flutter/foundation.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';

class TeachersProvider with ChangeNotifier {
  Teacher? _teacher;
  final List<Discipline> _teacherStudents = [];

  TeachersProvider();

  List<Discipline> get teachersStudents => [..._teacherStudents];

  Future<Teacher> getCachedTeacher() async {
    _teacher ??= Teacher(
      id: "t1",
      name: "Зинаида",
      lastName: "Юрьевна",
      fatherName: "Аркадьевна",
      birthDay: DateTime.now(),
      email: "",
      phone: "",
      imageUrl: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
      education: "",
    );
    return _teacher!;
  }

  void registerStudent(Student student) {}

  DateTime? getDisciplineNearestLesson(Discipline discipline) {
    DateTime? result;
    for (Lesson lesson in discipline.lessons) {
      if (result == null ||
          (lesson.dateTimeStart.isAfter(DateTime.now()) &&
              result.difference(DateTime.now()) > lesson.dateTimeStart.difference(DateTime.now()))) {
        result = lesson.dateTimeStart;
      }
    }
    return result;
  }

  Future<void> fetchTeacherStudents() async {
    _teacherStudents.clear();
    _teacherStudents.addAll(
      [
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
          rocketChatReference: [],
          minutes: 45,
          price: 1000,
        ),
      ],
    );
  }
}
