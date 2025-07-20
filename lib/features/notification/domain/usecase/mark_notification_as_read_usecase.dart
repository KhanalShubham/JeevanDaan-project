import 'package:jeevandaan/features/notification/domain/repository/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final INotificationRepository _repository;
  MarkNotificationAsReadUseCase(this._repository);
  Future<void> call(String notificationId) async {
    await _repository.markNotificationAsRead(notificationId);
  }
} 