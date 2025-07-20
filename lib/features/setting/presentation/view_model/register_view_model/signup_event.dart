import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignupNextStepTapped extends SignupEvent {
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
}

class SignupPreviousStepTapped extends SignupEvent {}

class SignupShowTermsTapped extends SignupEvent {
  final String type; // 'terms' or 'privacy'
  const SignupShowTermsTapped({required this.type});
}

class SignupTermsToggled extends SignupEvent {
  final bool hasAgreed;
  const SignupTermsToggled({required this.hasAgreed});
}