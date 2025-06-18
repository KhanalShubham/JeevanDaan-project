import 'package:flutter/material.dart';

@immutable
sealed class SignupEvent {}

class NavigateBackEvent extends SignupEvent {
  final BuildContext context;

  NavigateBackEvent({required this.context});
}

class SignupWithCredentialsEvent extends SignupEvent {
  final BuildContext context;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String gender;

  SignupWithCredentialsEvent({
    required this.context,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
  });
}

class UpdateGenderEvent extends SignupEvent {
  final String? gender;

  UpdateGenderEvent({required this.gender});
}

class ToggleTermsAgreementEvent extends SignupEvent {
  final bool agreed;

  ToggleTermsAgreementEvent({required this.agreed});
}

class ValidateFormEvent extends SignupEvent {}

class SocialSignupEvent extends SignupEvent {
  final BuildContext context;
  final String provider; // 'google', 'facebook'

  SocialSignupEvent({
    required this.context,
    required this.provider,
  });
}

class ShowTermsEvent extends SignupEvent {
  final BuildContext context;
  final String type; // 'terms' or 'privacy'

  ShowTermsEvent({
    required this.context,
    required this.type,
  });
}