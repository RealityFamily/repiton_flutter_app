// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discipline_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisciplineDTO _$DisciplineDTOFromJson(Map<String, dynamic> json) =>
    DisciplineDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      minutes: json['minutes'] as int,
      teacher: json['teacher'] == null
          ? null
          : TeacherDTO.fromJson(json['teacher'] as Map<String, dynamic>),
      student: json['student'] == null
          ? null
          : StudentDTO.fromJson(json['student'] as Map<String, dynamic>),
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => LessonDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      rocketChats: (json['rocketChats'] as List<dynamic>?)
          ?.map((e) => RocketChatDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DisciplineDTOToJson(DisciplineDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'minutes': instance.minutes,
      'teacher': instance.teacher,
      'student': instance.student,
      'lessons': instance.lessons,
      'rocketChats': instance.rocketChats,
    };
