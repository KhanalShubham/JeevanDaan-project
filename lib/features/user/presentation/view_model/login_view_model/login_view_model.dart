import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/boarding/presentation/view/boarding_view.dart';
import 'package:jeevandaan/features/user/presentation/view/signup.dart';
import 'package:jeevandaan/view/widget/mainnavigation.dart';
import 'login_event.dart';
import 'login_state.dart';
// Import your required dependencies
// import 'package:your_app/features/signup/signup.dart';
// import 'package:your_app/features/main_navigation/main_navigation.dart';
// import 'package:your_app/core/usecases/login_usecase.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  // Uncomment and inject your use case when ready
  // final LoginUsecase _loginUsecase;

  LoginViewModel(
    // this._loginUsecase
  ) : super(const LoginState.initial()) {
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
          builder: (context) => const Signup(), // Replace with your Signup widget
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
          builder: (context) => MainNavigation(), // Replace with your MainNavigation widget
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
      // Replace this with your actual login logic
      // final result = await _loginUsecase(
      //   LoginParams(
      //     emailOrPhone: event.emailOrPhone,
      //     password: event.password,
      //   ),
      // );

      // Simulate API call for now
      await Future.delayed(const Duration(seconds: 2));

      // Mock success - replace with actual result handling
      // result.fold(
      //   (failure) {
      //     emit(state.copyWith(
      //       isLoading: false,
      //       isSuccess: false,
      //       errorMessage: failure.message,
      //     ));
      //     
      //     if (event.context.mounted) {
      //       ScaffoldMessenger.of(event.context).showSnackBar(
      //         SnackBar(
      //           content: Text(failure.message),
      //           backgroundColor: Colors.red,
      //         ),
      //       );
      //     }
      //   },
      //   (token) {
      //     emit(state.copyWith(isLoading: false, isSuccess: true));
      //     add(NavigateToMainNavigationEvent(context: event.context));
      //   },
      // );

      // Mock implementation
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
    // Handle forgot password logic
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
    // Handle social login logic
    if (event.context.mounted) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text("${event.provider} sign in tapped")),
      );
    }
  }
}