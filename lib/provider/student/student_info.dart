import 'package:flutter/foundation.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/parent.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/repos/student_repo.dart';

class StudentInfoProvider with ChangeNotifier {
  Student? _student;
  List<Discipline> _studentDisciplines = [];

  final IStudentRepo _repo;

  StudentInfoProvider(this._repo);

  Student? get student => _student;
  List<Discipline> get studentDisciplines => [..._studentDisciplines];

  Future<void> fetchAndSetStudentForInfo(String studentId) async {
    _student = await _repo.getStudentById(studentId);
    _studentDisciplines = await _repo.getStudentsDisciplines(studentId);
    notifyListeners();
  }

  void addParent(Parent value) {
    if (_student == null) return;
    final parents = List<Parent>.from(_student!.parents);
    parents.add(value);
    final newStudent = _student!.copyWith(parents: parents);
    updateStudentInfo(newStudent);
  }

  void deleteParent(String parentId) {
    if (_student == null) return;
    final parents = List<Parent>.from(_student!.parents);
    parents.removeWhere((parent) => parent.id == parentId);
    final newStudent = _student!.copyWith(parents: parents);
    updateStudentInfo(newStudent);
  }

  Future<void> updateStudentInfo(Student newStudent) async {
    if (_student == null) return;
    _student = await _repo.updateStudentInfo(newStudent) ?? _student;
    notifyListeners();
  }
}
