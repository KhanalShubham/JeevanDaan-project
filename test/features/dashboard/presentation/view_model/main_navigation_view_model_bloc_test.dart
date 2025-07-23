import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_view_model.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_state.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';

class FakeLoginViewModel extends Fake implements LoginViewModel {}

void main() {
  group('MainNavigationViewModel Bloc Test', () {
    blocTest<MainNavigationViewModel, MainNavigationState>(
      'emits new state with selectedIndex when onTabTapped is called',
      build: () => MainNavigationViewModel(loginViewModel: FakeLoginViewModel()),
      act: (bloc) => bloc.onTabTapped(2),
      expect: () => [
        isA<MainNavigationState>().having((s) => s.selectedIndex, 'selectedIndex', 2),
      ],
    );
  });
} 