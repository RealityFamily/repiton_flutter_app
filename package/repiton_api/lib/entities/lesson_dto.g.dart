// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonDTO _$LessonDTOFromJson(Map<String, dynamic> json) => LessonDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      dateTimeStart: DateTime.parse(json['dateTimeStart'] as String),
      dateTimeEnd: DateTime.parse(json['dateTimeEnd'] as String),
      status: json['status'] as String,
      homeTask: (json['homeTask'] as List<dynamic>?)
          ?.map((e) => HomeTaskDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LessonDTOToJson(LessonDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'dateTimeStart': instance.dateTimeStart.toIso8601String(),
      'dateTimeEnd': instance.dateTimeEnd.toIso8601String(),
      'status': instance.status,
      'homeTask': instance.homeTask,
    };
