part of 'login_view_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when the user presses the "Sign In" button.
/// Contains the credentials needed for the business logic.
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

/// Event triggered when the user taps the visibility icon on the password field.
class TogglePasswordVisibility extends LoginEvent {}