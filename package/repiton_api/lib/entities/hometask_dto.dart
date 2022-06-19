import 'package:json_annotation/json_annotation.dart';
import 'package:repiton_api/entities/test_dto.dart';

part 'hometask_dto.g.dart';

@JsonSerializable()
class HomeTaskDTO {
  String id;
  String description;
  String mark;
  String markDescription;
  String type;
  TestDTO test;
  List<String> files;

  HomeTaskDTO({
    required this.id,
    required this.description,
    required this.mark,
    required this.markDescription,
    required this.type,
    required this.test,
    required this.files,
  });

  factory HomeTaskDTO.fromJson(Map<String, dynamic> json) => _$HomeTaskDTOFromJson(json);
  Map<String, dynamic> toJson() => _$HomeTaskDTOToJson(this);
}
