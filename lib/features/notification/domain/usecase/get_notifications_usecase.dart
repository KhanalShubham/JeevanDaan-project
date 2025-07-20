import 'package:jeevandaan/features/notification/domain/entities/notification_entity.dart';
import 'package:jeevandaan/features/notification/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  final INotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<List<NotificationEntity>> call() async {
    return await _repository.getNotifications();
  }
} 