import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_event.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_state.dart';

void main() {
  group('BoardingViewModel Bloc Test 4', () {
    blocTest<BoardingViewModel, BoardingState>(
      'resets navigation flags when ResetNavigationEvent is added',
      seed: () => const BoardingState.initial().copyWith(navigateToLogin: true, navigateToSignup: true),
      build: () => BoardingViewModel(),
      act: (bloc) => bloc.add(const ResetNavigationEvent()),
      expect: () => [
        const BoardingState.initial(),
      ],
    );
  });
} 