import 'package:flutter/foundation.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/parent.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/repos/discipline_repo.dart';
import 'package:repiton/repos/student_repo.dart';

class StudentInfoProvider with ChangeNotifier {
  Student? _student;
  List<Discipline> _studentDisciplines = [];

  final IStudentRepo _studentRepo;
  final IDisciplineRepo _disciplineRepo;

  StudentInfoProvider(this._studentRepo, this._disciplineRepo);

  Student? get student => _student;
  List<Discipline> get studentDisciplines => [..._studentDisciplines];

  Future<void> fetchAndSetStudentForInfo(String studentId) async {
    _student = await _studentRepo.getStudentById(studentId);
    _studentDisciplines = await _studentRepo.studentsDisciplines(studentId);
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
    _student = await _studentRepo.updateStudentInfo(newStudent) ?? _student;
    notifyListeners();
  }

  Discipline disciplineById(String disciplineId) => _studentDisciplines.firstWhere((discipline) => discipline.id == disciplineId);

  Future<void> updateDisciplineInfo(Discipline discipline) async {
    if (discipline.id == null) return;
    final newDiscipline = await _disciplineRepo.updateDiscipline(discipline);
    if (newDiscipline != null) {
      final foundDiscipline = _studentDisciplines.firstWhere((discipline) => discipline.id == newDiscipline.id);
      foundDiscipline.name = newDiscipline.name;
      foundDiscipline.price = newDiscipline.price;
      foundDiscipline.minutes = newDiscipline.minutes;

      notifyListeners();
    }
  }

  Future<void> deleteDiscipline(String disciplineId) async {
    final result = await _disciplineRepo.deleteDiscipline(disciplineId);
    if (result) {
      _studentDisciplines.removeWhere((discipline) => discipline.id == disciplineId);
      notifyListeners();
    }
  }
}
