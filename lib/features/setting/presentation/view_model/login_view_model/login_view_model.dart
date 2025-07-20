// lib/features/user/presentation/view_model/login_view_model/login_view_model.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_login_use_case.dart';
import 'package:jeevandaan/core/error/failure.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase _userLoginUseCase;

  LoginViewModel(this._userLoginUseCase) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    // The SignupNavigationRequested event doesn't need a handler here;
    // it will be handled directly by the UI's BlocListener.
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await _userLoginUseCase(
      UserLoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        emit(LoginFailure(error: failure.message));
      },
      (token) {
        emit(LoginSuccess());
      },
    );
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    if (state is LoginInitial) {
      final currentState = state as LoginInitial;
      emit(LoginInitial(obscureText: !currentState.obscureText));
    }
  }
}