import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/parent.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton_api/entities/discipline_dto.dart';
import 'package:repiton_api/entities/parent_dto.dart';
import 'package:repiton_api/entities/student_dto.dart';
import 'package:repiton_api/entities/teacher_dto.dart';

abstract class IDisciplineRepo {
  Future<Discipline?> addDiscipline(Discipline discipline);
  Future<Discipline?> updateDiscipline(Discipline discipline);
}

class DisciplineRepo implements IDisciplineRepo {
  RepitonApiContainer get _api => GetIt.I.get<RepitonApiContainer>();

  @override
  Future<Discipline?> updateDiscipline(Discipline discipline) async {
    try {
      final result = await _api.disciplineLesson.updateDiscipline(disciplineId: discipline.id!, discipline: discipline.toDTO);
      return result.toDiscipline;
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }

  @override
  Future<Discipline?> addDiscipline(Discipline discipline) async {
    try {
      final result = await _api.disciplineLesson.addDiscipline(discipline: discipline.toDTO);
      return result.toDiscipline;
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }
}

extension on Discipline {
  DisciplineDTO get toDTO => DisciplineDTO(
        id: id,
        name: name,
        price: price,
        minutes: minutes,
        teacher: teacher?.toDTO,
        student: student?.toDTO,
        lessons: null,
        rocketChats: null,
      );
}

extension on DisciplineDTO {
  Discipline get toDiscipline => Discipline(
        id: id,
        name: name,
        teacher: teacher!.toTeacher,
        student: student!.toStudent,
        lessons: [],
        price: price,
        minutes: minutes,
        rocketChatReference: [],
      );
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

extension on Student {
  StudentDTO get toDTO => StudentDTO(
        id: id,
        userName: userName,
        firstName: name,
        lastName: lastName,
        birthday: birthDay?.toIso8601String(),
        email: email,
        telephone: phone,
        imageUrl: imageUrl,
        education: education,
        parents: parents.map((parent) => parent.toDTO).toList(),
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

extension on Parent {
  ParentDTO get toDTO => ParentDTO(
        id: id,
        firstName: name,
        lastName: lastName,
        fatherName: fatherName,
        telephone: phone,
      );
}
