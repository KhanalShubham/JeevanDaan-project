import 'package:jeevandaan/features/chat/domain/repository/chat_repository.dart';

class SendTextMessageUseCase {
  final IChatRepository repository;
  SendTextMessageUseCase(this.repository);

  void call({required String message, required String toId}) {
    repository.sendTextMessage(message: message, toId: toId);
  }
}