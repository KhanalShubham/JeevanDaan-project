import 'package:jeevandaan/features/notification/data/data_source/notification_remote_data_source.dart';
import 'package:jeevandaan/features/notification/domain/entities/notification_entity.dart';
import 'package:jeevandaan/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final INotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(
      {required INotificationRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    return await _remoteDataSource.getNotifications();
  }
} 