import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

// Event for when the user taps the 'Continue' or 'Create Account' button
class SignupNextStepTapped extends SignupEvent {
  // Pass all controllers' text to the ViewModel for validation
  final String name;
  final String email;
  final String password;
  final String contact;
  final String disease;
  final String description;

  const SignupNextStepTapped({
    required this.name,
    required this.email,
    required this.password,
    required this.contact,
    required this.disease,
    required this.description,
  });

  @override
  List<Object?> get props => [name, email, password, contact, disease, description];
}

// Event for when the user taps the back arrow
class SignupPreviousStepTapped extends SignupEvent {
  final BuildContext context;
  const SignupPreviousStepTapped({required this.context});
  @override
  List<Object?> get props => [context];
}

// Event for toggling the checkbox
class SignupTermsToggled extends SignupEvent {
  final bool hasAgreed;
  const SignupTermsToggled({required this.hasAgreed});
  @override
  List<Object?> get props => [hasAgreed];
}

// Event for showing terms/privacy pop-up (this can stay the same)
class SignupShowTermsTapped extends SignupEvent {
  final BuildContext context;
  final String type; // 'terms' or 'privacy'

  const SignupShowTermsTapped({
    required this.context,
    required this.type,
  });

  @override
  List<Object?> get props => [context, type];
}