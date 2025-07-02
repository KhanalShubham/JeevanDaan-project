// features/user/presentation/view_model/login_view_model/login_event.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

// These two events are for navigation only, so they are allowed to have context.
class NavigateToSignupViewEvent extends LoginEvent {
  final BuildContext context;
  const NavigateToSignupViewEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class NavigateToMainNavigationEvent extends LoginEvent {
  final BuildContext context;
  const NavigateToMainNavigationEvent({required this.context});

  @override
  List<Object?> get props => [context];
}


// --- CORRECTED ---
// This event triggers business logic, so it should NOT have context.
class LoginWithCredentialsEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginWithCredentialsEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// This event is for a UI state change within the BLoC, it doesn't need context.
class TogglePasswordVisibilityEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}


// --- CORRECTED ---
// This event is for a simple UI action. The logic will be moved to the ViewModel/View listener.
// It does NOT need context.
class ForgotPasswordEvent extends LoginEvent {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

// --- REMOVED ---
// The SocialLoginEvent has been removed completely.