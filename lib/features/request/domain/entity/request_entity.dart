import 'package:equatable/equatable.dart';

class RequestEntity extends Equatable {
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

  const RequestEntity({
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

  const RequestEntity.empty()
      : id = null,
        filename = '',
        filePath = '',
        fileType = '',
        userImage = '',
        citizenshipImage = '',
        neededAmount = 0,
        originalAmount = 0,
        condition = '',
        inDepthStory = '',
        citizen = '',
        description = '',
        uploadedBy = '',
        status = 'pending',
        feedback = null,
        createdAt = null,
        updatedAt = null;

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