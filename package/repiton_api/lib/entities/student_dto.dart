import 'package:json_annotation/json_annotation.dart';
import 'package:repiton_api/entities/parent_dto.dart';

part 'student_dto.g.dart';

@JsonSerializable()
class StudentDTO {
  String? id;
  String? userName;
  String firstName;
  String lastName;
  String? birthday;
  String email;
  String? telephone;
  String? imageUrl;
  String? education;
  List<ParentDTO> parents;

  StudentDTO({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.email,
    required this.telephone,
    required this.imageUrl,
    required this.education,
    required this.parents,
  });

  factory StudentDTO.fromJson(Map<String, dynamic> json) => _$StudentDTOFromJson(json);
  Map<String, dynamic> toJson() => _$StudentDTOToJson(this);
}
