import 'package:json_annotation/json_annotation.dart';

part 'test_dto.g.dart';

@JsonSerializable()
class TestDTO {
  String id;

  TestDTO({
    required this.id,
  });

  factory TestDTO.fromJson(Map<String, dynamic> json) => _$TestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$TestDTOToJson(this);
}
