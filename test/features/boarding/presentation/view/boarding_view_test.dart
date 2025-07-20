import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevandaan/features/boarding/presentation/view/boarding_view.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_event.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_state.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockBoardingViewModel extends MockBloc<BoardingEvent, BoardingState>
    implements BoardingViewModel {}

void main() {
  late MockBoardingViewModel mockBoardingViewModel;

  setUp(() {
    mockBoardingViewModel = MockBoardingViewModel();
    whenListen(
      mockBoardingViewModel,
      Stream.fromIterable([const BoardingState.initial()]),
      initialState: const BoardingState.initial(),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<BoardingViewModel>.value(
        value: mockBoardingViewModel,
        child: const BoardingView(),
      ),
    );
  }

  group('BoardingView', () {
    testWidgets('adds NavigateToSignupEvent when "Create an account" is tapped', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      addTearDown(tester.view.reset); 

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Create an account'));

      verify(() => mockBoardingViewModel.add(const NavigateToSignupEvent())).called(1);
    });

    testWidgets('adds NavigateToLoginEvent when "Log In" is tapped', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Log In'));

      verify(() => mockBoardingViewModel.add(const NavigateToLoginEvent())).called(1);
    });
  });
}