import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_event.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_state.dart';

void main() {
  group('BoardingViewModel Bloc Test 2', () {
    blocTest<BoardingViewModel, BoardingState>(
      'emits [navigateToLogin: true] when NavigateToLoginEvent is added',
      build: () => BoardingViewModel(),
      act: (bloc) => bloc.add(const NavigateToLoginEvent()),
      expect: () => [
        const BoardingState.initial().copyWith(navigateToLogin: true),
      ],
    );
  });
} 