import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/main.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/dashboard.dart';

void main() {
  group('Simple Widget Tests', () {
    testWidgets('MainApp renders Hello World', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      expect(find.text('Hello World!'), findsOneWidget);
    });

    testWidgets('DashboardPage renders Dashboard Page text', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));
      expect(find.text('Dashboard Page'), findsOneWidget);
    });
  });
} 