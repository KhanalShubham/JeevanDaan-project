import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/user/presentation/view/signup.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:jeevandaan/view/widget/mainnavigation.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  LoginViewModel() : super(const LoginState.initial()) {
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
          builder: (context) => MainNavigation(),
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
      // TODO: Replace mock login with actual login logic using your authentication service
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(isLoading: false, isSuccess: true));
      
      if (event.context.mounted) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          const SnackBar(content: Text("Logged in successfully")),
        );
        add(NavigateToMainNavigationEvent(context: event.context));
      }
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