import 'package:jeevandaan/features/request/data/models/request_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_requests_dto.g.dart'; 

@JsonSerializable()
class GetAllRequestsDto {
  final bool success;
  final int count;
  final List<RequestApiModel> data;

  const GetAllRequestsDto({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllRequestsDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllRequestsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllRequestsDtoToJson(this);
}