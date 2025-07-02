import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';

part 'request_api_model.g.dart'; 

@JsonSerializable()
class RequestApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String filename;
  final String filePath;
  final String fileType;
  final String userImage;
  final String citizenshipImage;
  final num neededAmount;
  final num originalAmount;
  final String condition;
  final String inDepthStory;
  final String citizen;
  final String description;
  final String uploadedBy;
  final String status;
  final String? feedback;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RequestApiModel({
    this.id,
    required this.filename,
    required this.filePath,
    required this.fileType,
    required this.userImage,
    required this.citizenshipImage,
    required this.neededAmount,
    required this.originalAmount,
    required this.condition,
    required this.inDepthStory,
    required this.citizen,
    required this.description,
    required this.uploadedBy,
    required this.status,
    this.feedback,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for fromJson
  factory RequestApiModel.fromJson(Map<String, dynamic> json) =>
      _$RequestApiModelFromJson(json);

  // Method for toJson
  Map<String, dynamic> toJson() => _$RequestApiModelToJson(this);

  // Convert API Object to Entity
  RequestEntity toEntity() => RequestEntity(
        id: id,
        filename: filename,
        filePath: filePath,
        fileType: fileType,
        userImage: userImage,
        citizenshipImage: citizenshipImage,
        neededAmount: neededAmount,
        originalAmount: originalAmount,
        condition: condition,
        inDepthStory: inDepthStory,
        citizen: citizen,
        description: description,
        uploadedBy: uploadedBy,
        status: status,
        feedback: feedback,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  // Convert Entity to API Object (for outgoing data if needed, but not for file uploads directly)
  static RequestApiModel fromEntity(RequestEntity entity) => RequestApiModel(
        id: entity.id,
        filename: entity.filename,
        filePath: entity.filePath,
        fileType: entity.fileType,
        userImage: entity.userImage,
        citizenshipImage: entity.citizenshipImage,
        neededAmount: entity.neededAmount,
        originalAmount: entity.originalAmount,
        condition: entity.condition,
        inDepthStory: entity.inDepthStory,
        citizen: entity.citizen,
        description: entity.description,
        uploadedBy: entity.uploadedBy,
        status: entity.status,
        feedback: entity.feedback,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  // Convert API List to Entity List
  static List<RequestEntity> toEntityList(List<RequestApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        id,
        filename,
        filePath,
        fileType,
        userImage,
        citizenshipImage,
        neededAmount,
        originalAmount,
        condition,
        inDepthStory,
        citizen,
        description,
        uploadedBy,
        status,
        feedback,
        createdAt,
        updatedAt,
      ];
}