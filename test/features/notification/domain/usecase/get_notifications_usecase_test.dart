import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:jeevandaan/features/notification/domain/repository/notification_repository.dart';
import 'package:jeevandaan/features/notification/domain/entities/notification_entity.dart';

class MockNotificationRepository extends Mock implements INotificationRepository {}

void main() {
  test('returns notifications from repository', () async {
    final repo = MockNotificationRepository();
    final usecase = GetNotificationsUseCase(repo);
    final notifications = [
      const NotificationEntity(id: '1', title: 't', body: 'b', isRead: false),
    ];
    when(() => repo.getNotifications()).thenAnswer((_) async => notifications);
    final result = await usecase();
    expect(result, notifications);
    verify(() => repo.getNotifications()).called(1);
  });
}