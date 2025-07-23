import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/notification/domain/usecase/mark_all_notifications_as_read_usecase.dart';
import 'package:jeevandaan/features/notification/domain/repository/notification_repository.dart';

class MockNotificationRepository extends Mock implements INotificationRepository {}

void main() {
  test('calls markAllNotificationsAsRead on repository', () async {
    final repo = MockNotificationRepository();
    final usecase = MarkAllNotificationsAsReadUseCase(repo);
    when(() => repo.markAllNotificationsAsRead()).thenAnswer((_) async {});
    await usecase();
    verify(() => repo.markAllNotificationsAsRead()).called(1);
  });
}