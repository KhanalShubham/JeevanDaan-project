import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/features/boarding/presentation/view/boarding_view.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/splash/presentation/view/splash_view.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';

void main() {
  setUpAll(() {
    if (!serviceLocator.isRegistered<BoardingViewModel>()) {
      serviceLocator.registerFactory(() => BoardingViewModel());
    }
  });

  testWidgets(
      'SplashView should display UI and navigate to BoardingView after 2 seconds',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => SplashViewModel(),
        child: const MaterialApp(
          home: SplashView(),
        ),
      ),
    );

    // 2. Verify the initial UI
    expect(find.text('Jeevan Daan'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // 3. Simulate the 2-second delay
    await tester.pump(const Duration(seconds: 2));

    // 4. Trigger a frame to process the navigation
    await tester.pumpAndSettle();

    // 5. Verify successful navigation
    expect(find.byType(BoardingView), findsOneWidget);
    expect(find.byType(SplashView), findsNothing);
  });
}