// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_requests_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllRequestsDto _$GetAllRequestsDtoFromJson(Map<String, dynamic> json) =>
    GetAllRequestsDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => RequestApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllRequestsDtoToJson(GetAllRequestsDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
