import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:jeevandaan/features/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:jeevandaan/features/notification/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:jeevandaan/features/notification/domain/usecase/mark_all_notifications_as_read_usecase.dart';

class MockGetNotificationsUseCase extends Mock implements GetNotificationsUseCase {}
class MockMarkNotificationAsReadUseCase extends Mock implements MarkNotificationAsReadUseCase {}
class MockMarkAllNotificationsAsReadUseCase extends Mock implements MarkAllNotificationsAsReadUseCase {}

void main() {
  group('NotificationViewModel Bloc Test', () {
    late MockGetNotificationsUseCase getNotificationsUseCase;
    late MockMarkNotificationAsReadUseCase markNotificationAsReadUseCase;
    late MockMarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
    setUp(() {
      getNotificationsUseCase = MockGetNotificationsUseCase();
      markNotificationAsReadUseCase = MockMarkNotificationAsReadUseCase();
      markAllNotificationsAsReadUseCase = MockMarkAllNotificationsAsReadUseCase();
    });
    blocTest<NotificationViewModel, NotificationState>(
      'emits loading and error when GetNotifications throws',
      build: () {
        when(() => getNotificationsUseCase()).thenThrow(Exception('fail'));
        return NotificationViewModel(
          getNotificationsUseCase,
          markNotificationAsReadUseCase,
          markAllNotificationsAsReadUseCase,
        );
      },
      act: (bloc) => bloc.add(GetNotifications()),
      expect: () => [
        isA<NotificationLoading>(),
        isA<NotificationError>(),
      ],
    );
  });
} 