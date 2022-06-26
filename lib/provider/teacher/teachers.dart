import 'package:flutter/foundation.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/repos/teacher_repo.dart';

class TeachersProvider with ChangeNotifier {
  Teacher? _teacher;
  List<Discipline> _teacherDisciplines = [];
  final ITeacherRepo _repo;

  TeachersProvider(this._repo);

  List<Discipline> get teacherDisciplines => [..._teacherDisciplines];

  Future<Teacher> cachedTeacher() async {
    _teacher ??= await _repo.getTeacherById(RootProvider.getAuth().id);
    return _teacher ?? Teacher.empty();
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
    _teacherDisciplines = await _repo.teachersDisciplines();
  }
}
