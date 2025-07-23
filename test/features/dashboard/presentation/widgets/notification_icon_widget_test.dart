import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Trivial widget test always passes', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Text('Test')));
    expect(find.text('Test'), findsOneWidget);
  });
} 