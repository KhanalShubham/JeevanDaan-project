import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';
import 'package:jeevandaan/features/chat/domain/repository/chat_repository.dart';

class ListenForMessagesUseCase {
  final IChatRepository repository;
  ListenForMessagesUseCase(this.repository);

  Stream<MessageEntity> call() {
    return repository.getMessages();
  }
}