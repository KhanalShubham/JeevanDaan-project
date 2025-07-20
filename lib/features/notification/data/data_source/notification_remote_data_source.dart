import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/features/notification/data/model/notification_model.dart';

abstract class INotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl
    implements INotificationRemoteDataSource {
  final ApiService _apiService;

  NotificationRemoteDataSourceImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    // Implement API call to fetch notifications
    // final response = await _apiService.get('/notifications');
    // return (response.data as List).map((e) => NotificationModel.fromJson(e)).toList();
    return []; // Placeholder
  }
} 