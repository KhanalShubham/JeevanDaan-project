import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

class NavigateToSignupViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToSignupViewEvent({required this.context});
}

class NavigateToMainNavigationEvent extends LoginEvent {
  final BuildContext context;

  NavigateToMainNavigationEvent({required this.context});
}

class LoginWithCredentialsEvent extends LoginEvent {
  final BuildContext context;
  final String emailOrPhone;
  final String password;

  LoginWithCredentialsEvent({
    required this.context,
    required this.emailOrPhone,
    required this.password,
  });
}

class TogglePasswordVisibilityEvent extends LoginEvent {}

class ForgotPasswordEvent extends LoginEvent {
  final BuildContext context;

  ForgotPasswordEvent({required this.context});
}

class SocialLoginEvent extends LoginEvent {
  final BuildContext context;
  final String provider; // 'phone', 'gmail', 'facebook'

  SocialLoginEvent({
    required this.context,
    required this.provider,
  });
}