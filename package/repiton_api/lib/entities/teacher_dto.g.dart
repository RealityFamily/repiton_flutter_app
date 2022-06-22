// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherDTO _$TeacherDTOFromJson(Map<String, dynamic> json) => TeacherDTO(
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      fatherName: json['fatherName'] as String?,
      birthday: json['birthday'] as String?,
      email: json['email'] as String,
      telephone: json['telephone'] as String?,
      imageUrl: json['imageUrl'] as String?,
      education: json['education'] as String?,
    );

Map<String, dynamic> _$TeacherDTOToJson(TeacherDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fatherName': instance.fatherName,
      'birthday': instance.birthday,
      'email': instance.email,
      'telephone': instance.telephone,
      'imageUrl': instance.imageUrl,
      'education': instance.education,
    };
