import 'package:jeevandaan/features/notification/domain/repository/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase {
  final INotificationRepository _repository;
  MarkAllNotificationsAsReadUseCase(this._repository);
  Future<void> call() async {
    await _repository.markAllNotificationsAsRead();
  }
} 