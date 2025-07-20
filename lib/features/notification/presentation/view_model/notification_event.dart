part of 'notification_view_model.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;
  const MarkNotificationAsRead(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

class MarkAllNotificationsAsRead extends NotificationEvent {} 