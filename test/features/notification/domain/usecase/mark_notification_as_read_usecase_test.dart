import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/notification/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:jeevandaan/features/notification/domain/repository/notification_repository.dart';

class MockNotificationRepository extends Mock implements INotificationRepository {}

void main() {
  test('calls markNotificationAsRead on repository', () async {
    final repo = MockNotificationRepository();
    final usecase = MarkNotificationAsReadUseCase(repo);
    when(() => repo.markNotificationAsRead('id')).thenAnswer((_) async {});
    await usecase('id');
    verify(() => repo.markNotificationAsRead('id')).called(1);
  });
}