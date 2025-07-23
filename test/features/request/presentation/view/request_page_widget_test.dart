import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/requestPage.dart';

void main() {
  testWidgets('RequestPage renders and shows Request text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RequestPage(),
      ),
    );
    expect(find.textContaining('Request'), findsWidgets);
    await tester.pumpAndSettle();
  });
} 