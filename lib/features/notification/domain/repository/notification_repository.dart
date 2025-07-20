import 'package:jeevandaan/features/notification/domain/entities/notification_entity.dart';

abstract class INotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
} 