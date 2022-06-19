import 'package:json_annotation/json_annotation.dart';

part 'teacher_dto.g.dart';

@JsonSerializable()
class TeacherDTO {
  String id;
  String userName;
  String firstName;
  String lastName;
  String fatherName;
  String birthday;
  String email;
  String telephone;
  String imageUrl;
  String education;

  TeacherDTO({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.birthday,
    required this.email,
    required this.telephone,
    required this.imageUrl,
    required this.education,
  });

  factory TeacherDTO.fromJson(Map<String, dynamic> json) => _$TeacherDTOFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherDTOToJson(this);
}
