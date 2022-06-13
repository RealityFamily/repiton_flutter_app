// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hometask_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeTaskDTO _$HomeTaskDTOFromJson(Map<String, dynamic> json) => HomeTaskDTO(
      id: json['id'] as String,
      description: json['description'] as String,
      mark: json['mark'] as String,
      markDescription: json['markDescription'] as String,
      type: json['type'] as String,
      test: TestDTO.fromJson(json['test'] as Map<String, dynamic>),
      files: (json['files'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$HomeTaskDTOToJson(HomeTaskDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'mark': instance.mark,
      'markDescription': instance.markDescription,
      'type': instance.type,
      'test': instance.test,
      'files': instance.files,
    };
