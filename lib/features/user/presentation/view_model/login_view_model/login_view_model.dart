import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/boarding/presentation/view/boarding_view.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_login_use_case.dart';
import 'package:jeevandaan/features/user/presentation/view/signup.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase _userLoginUseCase;

  LoginViewModel({required IUserRepository userRepository})
      : _userLoginUseCase = UserLoginUseCase(userRepository: userRepository),
        super(const LoginState.initial()) {
    on<NavigateToSignupViewEvent>(_onNavigateToSignupView);
    on<NavigateToMainNavigationEvent>(_onNavigateToMainNavigation);
    on<LoginWithCredentialsEvent>(_onLoginWithCredentials);
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<SocialLoginEvent>(_onSocialLogin);
  }

  void _onNavigateToSignupView(
    NavigateToSignupViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => const Signup(),
        ),
      );
    }
  }

  void _onNavigateToMainNavigation(
    NavigateToMainNavigationEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => const BoardingView(),
        ),
      );
    }
  }

  void _onLoginWithCredentials(
    LoginWithCredentialsEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await _userLoginUseCase(
        LoginUserParams(
          email: event.email,
          password: event.password,
        ),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: failure.message,
          ));
          if (event.context.mounted) {
            ScaffoldMessenger.of(event.context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (_) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
          if (event.context.mounted) {
            ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(content: Text("Logged in successfully")),
            );
            add(NavigateToMainNavigationEvent(context: event.context));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      ));
      if (event.context.mounted) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text("Login failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibilityEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(obscureText: !state.obscureText));
  }

  void _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(content: Text("Forgot password feature coming soon")),
      );
    }
  }

  void _onSocialLogin(
    SocialLoginEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text("${event.provider} sign in tapped")),
      );
    }
  }
}