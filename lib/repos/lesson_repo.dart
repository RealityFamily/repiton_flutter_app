import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/remote_file.dart';
import 'package:repiton/model/test.dart';
import 'package:repiton_api/entities/hometask_dto.dart';
import 'package:repiton_api/entities/lesson_dto.dart';
import 'package:repiton_api/entities/test_dto.dart';

abstract class ILessonRepo {
  Future<Lesson?> updateLesson(Lesson newLesson);
  Future startLesson(String lessonId);
  Future endLesson(String lessonId);
}

class LessonRepo implements ILessonRepo {
  RepitonApiContainer get _api => GetIt.I.get<RepitonApiContainer>();

  @override
  Future<Lesson?> updateLesson(Lesson newLesson) async {
    try {
      final result = await _api.disciplineLesson.updateLessonInfo(lessonId: newLesson.id, newLesson: newLesson.toDTO);
      return result.toLesson;
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }

  @override
  Future endLesson(String lessonId) async {
    try {
      /*final result = */ await _api.disciplineLesson.endLesson(lessonId: lessonId);
      // return result.toLesson;
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      // return null;
    }
  }

  @override
  Future startLesson(String lessonId) async {
    try {
      /*final result = */ await _api.disciplineLesson.startLesson(lessonId: lessonId);
      // return result.toLesson;
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      // return null;
    }
  }
}

extension on Lesson {
  LessonDTO get toDTO => LessonDTO(
        id: id,
        name: name,
        description: description,
        dateTimeStart: dateTimeStart,
        dateTimeEnd: dateTimeEnd,
        status: Lesson.lessonStatusToString(status),
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
