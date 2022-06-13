import 'package:json_annotation/json_annotation.dart';

part 'parent_dto.g.dart';

@JsonSerializable()
class ParentDTO {
  String id;
  String firstName;
  String lastName;
  String fatherName;
  String telephone;

  ParentDTO({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.telephone,
  });

  factory ParentDTO.fromJson(Map<String, dynamic> json) => _$ParentDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ParentDTOToJson(this);
}
