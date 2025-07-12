import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/chat/domain/repository/chat_repository.dart';

class SendChatFileUseCase {
  final IChatRepository repository;
  SendChatFileUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(File file) async {
    return await repository.sendChatFile(file);
  }
}