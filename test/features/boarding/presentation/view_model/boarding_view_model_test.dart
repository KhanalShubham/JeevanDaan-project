import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_event.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_state.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';

void main() {
  group('BoardingViewModel', () {
    test('initial state is BoardingState.initial()', () {
      expect(BoardingViewModel().state, const BoardingState.initial());
    });

    blocTest<BoardingViewModel, BoardingState>(
      'emits state with navigateToSignup: true when NavigateToSignupEvent is added',
      build: () => BoardingViewModel(),
      act: (bloc) => bloc.add(const NavigateToSignupEvent()),
      // CORRECTED: Use copyWith from the initial state for clarity and correctness.
      expect: () => [
        const BoardingState.initial().copyWith(navigateToSignup: true),
      ],
    );

    blocTest<BoardingViewModel, BoardingState>(
      'emits state with navigateToLogin: true when NavigateToLoginEvent is added',
      build: () => BoardingViewModel(),
      act: (bloc) => bloc.add(const NavigateToLoginEvent()),
      // CORRECTED: Use copyWith.
      expect: () => [
        const BoardingState.initial().copyWith(navigateToLogin: true),
      ],
    );
    
    blocTest<BoardingViewModel, BoardingState>(
      'emits state with isCreateAccountHovered: true when CreateAccountHoverEvent(true) is added',
      build: () => BoardingViewModel(),
      act: (bloc) => bloc.add(const CreateAccountHoverEvent(true)),
      // CORRECTED: Use copyWith.
      expect: () => [
        const BoardingState.initial().copyWith(isCreateAccountHovered: true),
      ],
    );

    blocTest<BoardingViewModel, BoardingState>(
      'resets navigation flags when ResetNavigationEvent is added',
      // Seed the bloc with a state where navigation is active.
      seed: () => const BoardingState.initial().copyWith(navigateToLogin: true, navigateToSignup: true),
      build: () => BoardingViewModel(),
      act: (bloc) => bloc.add(const ResetNavigationEvent()),
      // Expect the state to return to the initial state where flags are false.
      expect: () => [
        const BoardingState.initial(),
      ],
    );
  });
}