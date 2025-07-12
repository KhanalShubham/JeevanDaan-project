import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String? message;
  final String? fileUrl;
  final String? fileName;
  final String messageType;
  final DateTime timestamp;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.message,
    this.fileUrl,
    this.fileName,
    required this.messageType,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id];
}