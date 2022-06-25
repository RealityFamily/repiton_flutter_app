import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/parent.dart';
import 'package:repiton/model/remote_file.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/model/test.dart';
import 'package:repiton_api/entities/discipline_dto.dart';
import 'package:repiton_api/entities/hometask_dto.dart';
import 'package:repiton_api/entities/lesson_dto.dart';
import 'package:repiton_api/entities/parent_dto.dart';
import 'package:repiton_api/entities/student_dto.dart';
import 'package:repiton_api/entities/teacher_dto.dart';
import 'package:repiton_api/entities/test_dto.dart';

abstract class IStudentRepo {
  Future<List<Discipline>> getTimetable(String studentId, DateTime dateTimeFrom, DateTime dateTimeTo);
  Future<List<Discipline>> getStudentsDisciplines(String studentId);
  Future<Student?> getStudentById(String studentId);
  Future<Student?> updateStudentInfo(Student student);
}

class StudentRepo implements IStudentRepo {
  RepitonApiContainer get _api => GetIt.I.get<RepitonApiContainer>();

  @override
  Future<List<Discipline>> getTimetable(String studentId, DateTime dateTimeFrom, DateTime dateTimeTo) async {
    try {
      final result = await _api.disciplineLesson.studentTimetable(
        studentId: studentId,
        dateFrom: dateTimeFrom.toIso8601String(),
        dateTo: dateTimeTo.toIso8601String(),
      );
      return result.map((dto) => dto.toDiscipline).toList();
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return [];
    }
  }

  @override
  Future<Student?> getStudentById(String studentId) async {
    try {
      final result = await _api.user.getStudentById(studentId: studentId);
      return result.toStudent;
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }

  @override
  Future<List<Discipline>> getStudentsDisciplines(String studentId) {
    // TODO: implement getStudentsDisciplines
    throw UnimplementedError();
  }

  @override
  Future<Student?> updateStudentInfo(Student student) async {
    try {
      final result = await _api.user.updateStudent(studentId: student.id!, student: student.toDTO);
      return result.toStudent;
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }
}

extension on DisciplineDTO {
  Discipline get toDiscipline => Discipline(
        id: id,
        name: name,
        teacher: teacher.toTeacher,
        student: student.toStudent,
        lessons: lessons.map((dto) => dto.toLesson).toList(),
        rocketChatReference: rocketChats.map((dto) => dto.channelName).toList(),
        minutes: minutes,
        price: price,
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

extension on LessonDTO {
  Lesson get toLesson => Lesson(
      id: id,
      name: name,
      description: description,
      status: Lesson.stringToLessonStatus(status),
      dateTimeStart: dateTimeStart,
      dateTimeEnd: dateTimeEnd,
      homeTask: homeTask?.map((dto) => dto.toHomeTask).toList());
}

extension on HomeTaskDTO {
  HomeTask get toHomeTask => HomeTask(
        id: id,
        description: description,
        type: HomeTask.stringToHomeTaskType(type),
        test: test.toTest,
        files: files.map((dto) => RemoteFile(name: dto)).toList(),
      );
}

extension on TestDTO {
  Test get toTest => Test(id: id);
}
