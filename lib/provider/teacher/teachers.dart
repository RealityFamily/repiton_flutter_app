import 'package:flutter/foundation.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/repos/teacher_repo.dart';

class TeachersProvider with ChangeNotifier {
  Teacher? _teacher;
  final List<Discipline> _teacherStudents = [];
  final ITeacherRepo _repo;

  TeachersProvider(this._repo);

  List<Discipline> get teachersStudents => [..._teacherStudents];

  Future<Teacher> cachedTeacher() async {
    _teacher ??= await _repo.getTeacherById(RootProvider.getAuth().id);
    return _teacher ?? Teacher.empty();
  }

  Future<List<Teacher>> choosableTeacher() async {
    _teacher ??= await _repo.getTeacherById(RootProvider.getAuth().id);
    return [(_teacher ?? Teacher.empty())];
  }

  void registerStudent(Student student) {}

  DateTime? getDisciplineNearestLesson(Discipline discipline) {
    DateTime? result;
    for (Lesson lesson in discipline.lessons) {
      if (result == null || (lesson.dateTimeStart.isAfter(DateTime.now()) && result.difference(DateTime.now()) > lesson.dateTimeStart.difference(DateTime.now()))) {
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
              id: "lesson4",
              name: "Урок №4",
              description: "Какая-то инфа по уроку",
              status: LessonStatus.planned,
              dateTimeStart: DateTime.now(),
              dateTimeEnd: DateTime.now(),
            ),
            Lesson(
              id: "lesson5",
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
