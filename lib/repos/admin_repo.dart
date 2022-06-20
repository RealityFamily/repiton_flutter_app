import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton/model/parent.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton_api/entities/parent_dto.dart';
import 'package:repiton_api/entities/student_dto.dart';
import 'package:repiton_api/entities/teacher_dto.dart';

abstract class IAdminRepo {
  Future<List<Teacher>> getTeachers();
  Future<List<Student>> getStudents();
  Future<Teacher?> addTeacher(Teacher newTeacher);
}

class AdminRepo implements IAdminRepo {
  RepitonApiContainer get _api => GetIt.I.get<RepitonApiContainer>();

  @override
  Future<List<Student>> getStudents() async {
    try {
      final result = await _api.user.getAllStudents();
      return result.map((dto) => dto.toStudent).toList();
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return [];
    }
  }

  @override
  Future<List<Teacher>> getTeachers() async {
    try {
      final result = await _api.user.getAllTeachers();
      return result.map((dto) => dto.toTeacher).toList();
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return [];
    }
  }

  @override
  Future<Teacher?> addTeacher(Teacher newTeacher) async {
    try {
      final result = await _api.user.addTeacher(teacher: newTeacher.toDTO);
      return result.toTeacher;
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }
}

extension on TeacherDTO {
  Teacher get toTeacher => Teacher(
        id: id,
        name: firstName,
        lastName: lastName,
        fatherName: fatherName,
        birthDay: birthday != null ? DateTime.parse(birthday!) : null,
        email: email,
        phone: telephone,
        imageUrl: imageUrl,
        education: education,
      );
}

extension on Teacher {
  TeacherDTO get toDTO => TeacherDTO(
        id: id,
        userName: userName,
        firstName: name,
        lastName: lastName,
        fatherName: fatherName,
        birthday: birthDay?.toIso8601String(),
        email: email,
        telephone: phone,
        imageUrl: imageUrl,
        education: education,
      );
}

extension on StudentDTO {
  Student get toStudent => Student(
        id: id,
        name: firstName,
        lastName: lastName,
        birthDay: birthday != null ? DateTime.parse(birthday!) : null,
        email: email,
        phone: telephone,
        imageUrl: imageUrl,
        education: education,
        parents: parents.map((dto) => dto.toParent).toList(),
      );
}

extension on ParentDTO {
  Parent get toParent => Parent(
        id: id,
        name: firstName,
        lastName: lastName,
        fatherName: fatherName,
        phone: telephone,
      );
}
