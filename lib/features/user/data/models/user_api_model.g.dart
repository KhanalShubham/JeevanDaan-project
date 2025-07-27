// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      userId: json['_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      disease: json['disease'] as String,
      contact: json['contact'] as String,
      description: json['description'] as String,
      password: json['password'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'disease': instance.disease,
      'contact': instance.contact,
      'description': instance.description,
      'password': instance.password,
      'photoUrl': instance.photoUrl,
      'role': instance.role,
    };
