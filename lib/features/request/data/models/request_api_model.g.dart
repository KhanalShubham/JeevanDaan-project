// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestApiModel _$RequestApiModelFromJson(Map<String, dynamic> json) =>
    RequestApiModel(
      id: json['_id'] as String?,
      filename: json['filename'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String,
      userImage: json['userImage'] as String,
      citizenshipImage: json['citizenshipImage'] as String,
      neededAmount: json['neededAmount'] as num,
      originalAmount: json['originalAmount'] as num,
      condition: json['condition'] as String,
      inDepthStory: json['inDepthStory'] as String,
      citizen: json['citizen'] as String,
      description: json['description'] as String,
      uploadedBy: json['uploadedBy'] as String,
      status: json['status'] as String,
      feedback: json['feedback'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RequestApiModelToJson(RequestApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'filename': instance.filename,
      'filePath': instance.filePath,
      'fileType': instance.fileType,
      'userImage': instance.userImage,
      'citizenshipImage': instance.citizenshipImage,
      'neededAmount': instance.neededAmount,
      'originalAmount': instance.originalAmount,
      'condition': instance.condition,
      'inDepthStory': instance.inDepthStory,
      'citizen': instance.citizen,
      'description': instance.description,
      'uploadedBy': instance.uploadedBy,
      'status': instance.status,
      'feedback': instance.feedback,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
