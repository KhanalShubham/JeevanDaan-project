import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/notification/presentation/views/notification_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/notification/presentation/view_model/notification_view_model.dart';

class FakeNotificationViewModel extends Mock implements NotificationViewModel {
  @override
  Stream<NotificationState> get stream => const Stream<NotificationState>.empty();
  @override
  NotificationState get state => NotificationInitial();
  @override
  Future<void> close() => Future.value();
}

void main() {
  testWidgets('NotificationScreen renders and shows Notifications text', (WidgetTester tester) async {
    final fakeBloc = FakeNotificationViewModel();
    await tester.pumpWidget(
      BlocProvider<NotificationViewModel>.value(
        value: fakeBloc,
        child: const MaterialApp(
          home: NotificationScreen(),
        ),
      ),
    );
    expect(find.textContaining('Notifications'), findsOneWidget);
    await tester.pumpAndSettle();
  });
} 