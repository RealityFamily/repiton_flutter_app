import 'package:json_annotation/json_annotation.dart';
import 'package:repiton_api/entities/hometask_dto.dart';

part 'lesson_dto.g.dart';

@JsonSerializable()
class LessonDTO {
  String id;
  String name;
  String description;
  DateTime dateTimeStart;
  DateTime dateTimeEnd;
  String status;
  List<HomeTaskDTO>? homeTask;

  LessonDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.status,
    this.homeTask,
  });

  factory LessonDTO.fromJson(Map<String, dynamic> json) => _$LessonDTOFromJson(json);
  Map<String, dynamic> toJson() => _$LessonDTOToJson(this);
}
