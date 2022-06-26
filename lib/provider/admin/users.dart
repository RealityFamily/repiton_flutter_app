import 'package:flutter/foundation.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/repos/admin_repo.dart';

class UsersProvider with ChangeNotifier {
  final List<Teacher> _teachersList = [];
  final List<Student> _studentsList = [];
  final IAdminRepo _repo;

  UsersProvider(this._repo);

  List<Teacher> get teachersList => [..._teachersList];
  List<Student> get studentsList => [..._studentsList];

  Future<void> fetchTeachers() async {
    _teachersList.clear();
    _teachersList.addAll(await _repo.getTeachers());
    notifyListeners();
  }

  void addTeacher(Teacher newTeacher) async {
    final savedTeacher = await _repo.addTeacher(newTeacher);
    if (savedTeacher != null) {
      _teachersList.add(savedTeacher);
      notifyListeners();
    }
  }

  Future<void> fetchStudents() async {
    _studentsList.clear();
    _studentsList.addAll(await _repo.getStudents());
    notifyListeners();
  }
}
