// features/user/presentation/view_model/login_view_model/login_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/boarding/presentation/view/boarding_view.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/mainnavigation.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_view_model.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_login_use_case.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:jeevandaan/features/user/presentation/view/signup.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase _userLoginUseCase;

  LoginViewModel(this._userLoginUseCase) : super(const LoginState.initial()) {
    on<NavigateToSignupViewEvent>(_onNavigateToSignupView);
    on<NavigateToMainNavigationEvent>(_onNavigateToMainNavigation);
    on<LoginWithCredentialsEvent>(_onLoginWithCredentials);
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<ForgotPasswordEvent>(_onForgotPassword);
    // REMOVED: The handler for SocialLoginEvent
  }

  // --- CORRECTED ---
  // This method now only handles business logic and emits state. No UI calls.
  void _onLoginWithCredentials(
    LoginWithCredentialsEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _userLoginUseCase(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        // ViewModel's job: Report the failure state.
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: failure.message,
        ));
      },
      (token) {
        // ViewModel's job: Report the success state.
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
    );
  }

  // This method's only job is navigation, so it's OK.
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

  // This method's only job is navigation, so it's OK.
  void _onNavigateToMainNavigation(
    NavigateToMainNavigationEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            // Make sure serviceLocator is available or passed in.
            // For now, assuming it's a global singleton.
            value: serviceLocator<MainNavigationViewModel>(),
            child:  MainNavigation(),
          ),
        ),
        (route) => false,
      );
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibilityEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(obscureText: !state.obscureText));
  }

  // --- CORRECTED ---
  // This method no longer performs UI actions. We can enhance it later if needed.
  // For now, it does nothing, but you could emit a state to show a dialog.
  void _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<LoginState> emit,
  ) {
    // In a real app, you might emit a state like:
    // emit(state.copyWith(showForgotPasswordDialog: true));
    // For now, we leave the SnackBar logic in the View if needed, or do nothing.
    print("Forgot Password Tapped - Logic to be handled in ViewModel or a dedicated flow.");
  }

  // --- REMOVED ---
  // The _onSocialLogin method is no longer needed.
}