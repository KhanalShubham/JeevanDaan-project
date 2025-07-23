import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/message.dart';

void main() {
  testWidgets('MessagePage renders and shows Message text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MessagePage(),
      ),
    );
    expect(find.textContaining('Message'), findsWidgets);
    await tester.pumpAndSettle();
  });
} 