import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    super.message,
    super.fileUrl,
    super.fileName,
    required super.messageType,
    required super.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] ?? {'_id': 'unknown', 'name': 'Anonymous'};
    return MessageModel(
      id: json['_id'],
      senderId: sender['_id'],
      senderName: sender['name'] ?? 'Anonymous',
      message: json['message'],
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      messageType: json['messageType'] ?? 'text',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  MessageEntity toEntity() => this;
}