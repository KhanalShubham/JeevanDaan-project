import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class NavigateBackEvent extends SignupEvent {
  final BuildContext context;

  const NavigateBackEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class SignupWithCredentialsEvent extends SignupEvent {
  final BuildContext context;
  final String name;
  final String email;
  final String contact;
  final String password;
  final String disease;
  final String description;

  const SignupWithCredentialsEvent({
    required this.context,
    required this.name,
    required this.email,
    required this.contact,
    required this.password,
    required this.disease,
    required this.description,
  });

  @override
  List<Object?> get props => [
        context,
        name,
        email,
        contact,
        password,
        disease,
        description,
      ];
}

class ToggleTermsAgreementEvent extends SignupEvent {
  final bool agreed;

  const ToggleTermsAgreementEvent({required this.agreed});

  @override
  List<Object?> get props => [agreed];
}

class ValidateFormEvent extends SignupEvent {
  @override
  List<Object?> get props => [];
}

class ShowTermsEvent extends SignupEvent {
  final BuildContext context;
  final String type; // 'terms' or 'privacy'

  const ShowTermsEvent({
    required this.context,
    required this.type,
  });

  @override
  List<Object?> get props => [context, type];
}