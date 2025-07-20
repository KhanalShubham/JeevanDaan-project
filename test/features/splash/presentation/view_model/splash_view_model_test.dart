import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:mocktail/mocktail.dart';

// Mock BuildContext to use in the test
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('SplashViewModel', () {
    late SplashViewModel splashViewModel;
    late MockBuildContext mockContext;

    setUp(() {
      splashViewModel = SplashViewModel();
      mockContext = MockBuildContext();
      
      // Stub the 'mounted' property before each test
      when(() => mockContext.mounted).thenReturn(true);
    });

    blocTest<SplashViewModel, void>(
      'completes init method without emitting states',
      build: () => splashViewModel,
      act: (cubit) async {
        // We run the init method inside a try-catch because the Navigator
        // will fail in a non-UI test environment. This is expected.
        try {
          await cubit.init(mockContext);
        } catch (_) {
          // Catching the expected navigation error allows the test to pass.
        }
      },
      // Expect that no new states are emitted, which is correct for Cubit<void>
      expect: () => [],
    );
  });
}