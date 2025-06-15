import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_event.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_state.dart';

class BoardingViewModel extends Bloc<BoardingEvent, BoardingState> {
  BoardingViewModel() : super(const BoardingState()) {
    on<CreateAccountHoverEvent>(_onCreateAccountHover);
    on<LoginHoverEvent>(_onLoginHover);
    on<NavigateToSignupEvent>(_onNavigateToSignup);
    on<NavigateToLoginEvent>(_onNavigateToLogin);
  }

  void _onCreateAccountHover(CreateAccountHoverEvent event, Emitter<BoardingState> emit) {
    emit(state.copyWith(isCreateAccountHovered: event.isHovered));
  }

  void _onLoginHover(LoginHoverEvent event, Emitter<BoardingState> emit) {
    emit(state.copyWith(isLoginHovered: event.isHovered));
  }

  void _onNavigateToSignup(NavigateToSignupEvent event, Emitter<BoardingState> emit) {
    emit(state.copyWith(navigateToSignup: true));
  }

  void _onNavigateToLogin(NavigateToLoginEvent event, Emitter<BoardingState> emit) {
    emit(state.copyWith(navigateToLogin: true));
  }
}