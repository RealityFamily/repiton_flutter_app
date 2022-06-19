import 'package:json_annotation/json_annotation.dart';
import 'package:repiton_api/entities/lesson_dto.dart';
import 'package:repiton_api/entities/rocket_chat_dto.dart';
import 'package:repiton_api/entities/student_dto.dart';
import 'package:repiton_api/entities/teacher_dto.dart';

part 'discipline_dto.g.dart';

@JsonSerializable()
class DisciplineDTO {
  String id;
  String name;
  double price;
  int minutes;
  TeacherDTO teacher;
  StudentDTO student;
  List<LessonDTO> lessons;
  List<RocketChatDTO> rocketChats;

  DisciplineDTO({
    required this.id,
    required this.name,
    required this.price,
    required this.minutes,
    required this.teacher,
    required this.student,
    required this.lessons,
    required this.rocketChats,
  });

  factory DisciplineDTO.fromJson(Map<String, dynamic> json) => _$DisciplineDTOFromJson(json);
  Map<String, dynamic> toJson() => _$DisciplineDTOToJson(this);
}
