import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';
import 'package:jeevandaan/features/chat/domain/repository/chat_repository.dart';

class GetChatHistoryUseCase {
  final IChatRepository repository;
  GetChatHistoryUseCase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call(String otherUserId) async {
    return await repository.getChatHistory(otherUserId);
  }
}