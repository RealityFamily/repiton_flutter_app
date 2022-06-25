import 'package:flutter/foundation.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/repos/student_repo.dart';

class StudentsProvider with ChangeNotifier {
  Student? _student;
  final IStudentRepo _repo;

  StudentsProvider(this._repo);

  Future<Student> cachedStudent() async {
    _student ??= await _repo.getStudentById(RootProvider.getAuth().id);
    return _student!;
  }

  Future<List<Student>> choosableStudent(String studentId) async {
    return [await _repo.getStudentById(studentId) ?? Student.empty()];
  }
}
