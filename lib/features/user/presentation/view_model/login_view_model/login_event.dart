import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

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

class LoginWithCredentialsEvent extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;

  const LoginWithCredentialsEvent({
    required this.email,
    required this.password,
    required this.context,
  });

  @override
  List<Object?> get props => [email, password, context];
}

class TogglePasswordVisibilityEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordEvent extends LoginEvent {
  final BuildContext context;

  const ForgotPasswordEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class SocialLoginEvent extends LoginEvent {
  final BuildContext context;
  final String provider;

  const SocialLoginEvent({required this.context, required this.provider});

  @override
  List<Object?> get props => [context, provider];
}