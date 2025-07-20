import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/features/notification/data/model/notification_model.dart';
import 'package:dio/dio.dart';

abstract class INotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> markAllNotificationsAsRead();
}

class NotificationRemoteDataSourceImpl
    implements INotificationRemoteDataSource {
  final ApiService _apiService;

  NotificationRemoteDataSourceImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiService.dio.get('/notifications');
    final data = response.data;
    if (data['success'] == true && data['notifications'] is List) {
      return (data['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    await _apiService.dio.post(
      '/notifications/mark-read',
      data: { 'notificationId': notificationId },
      options: Options(contentType: 'application/json'),
    );
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    await _apiService.dio.post(
      '/notifications/mark-all-read',
      options: Options(contentType: 'application/json'),
    );
  }
} 