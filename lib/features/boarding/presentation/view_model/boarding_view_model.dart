import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_event.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_state.dart';

class BoardingViewModel extends Bloc<BoardingEvent, BoardingState> {
  // REFINED: Using the new .initial() constructor and inline event handlers.
  BoardingViewModel() : super(const BoardingState.initial()) {
    on<CreateAccountHoverEvent>((event, emit) {
      emit(state.copyWith(isCreateAccountHovered: event.isHovered));
    });

    on<LoginHoverEvent>((event, emit) {
      emit(state.copyWith(isLoginHovered: event.isHovered));
    });

    on<NavigateToSignupEvent>((event, emit) {
      emit(state.copyWith(navigateToSignup: true));
    });

    on<NavigateToLoginEvent>((event, emit) {
      emit(state.copyWith(navigateToLogin: true));
    });

    // ADDED: Handler for the new reset event.
    // This handler's only job is to reset all navigation flags to false.
    on<ResetNavigationEvent>((event, emit) {
      emit(state.copyWith(
        navigateToSignup: false,
        navigateToLogin: false,
      ));
    });
  }
}