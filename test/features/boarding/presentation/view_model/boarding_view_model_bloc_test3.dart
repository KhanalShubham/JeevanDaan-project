import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_event.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_state.dart';

void main() {
  group('BoardingViewModel Bloc Test 3', () {
    blocTest<BoardingViewModel, BoardingState>(
      'emits [isCreateAccountHovered: true] when CreateAccountHoverEvent(true) is added',
      build: () => BoardingViewModel(),
      act: (bloc) => bloc.add(const CreateAccountHoverEvent(true)),
      expect: () => [
        const BoardingState.initial().copyWith(isCreateAccountHovered: true),
      ],
    );
  });
} 