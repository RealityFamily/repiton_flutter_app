// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentDTO _$ParentDTOFromJson(Map<String, dynamic> json) => ParentDTO(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      fatherName: json['fatherName'] as String,
      telephone: json['telephone'] as String,
    );

Map<String, dynamic> _$ParentDTOToJson(ParentDTO instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fatherName': instance.fatherName,
      'telephone': instance.telephone,
    };
