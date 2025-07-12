import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';

abstract class IChatRepository {
  Future<Either<Failure, List<MessageEntity>>> getChatHistory(String otherUserId);
  Future<Either<Failure, Map<String, dynamic>>> sendChatFile(File file);
  
  // For real-time messaging
  Future<void>connect();
  void disconnect();
  void sendTextMessage({required String message, required String toId});
  void sendFileMessageAfterUpload({required Map<String, dynamic> fileData, required String toId});
  Stream<MessageEntity> getMessages(); // Listens for new messages
}