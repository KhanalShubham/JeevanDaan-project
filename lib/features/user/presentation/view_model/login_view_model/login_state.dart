// lib/features/user/presentation/view_model/login_view_model/login_state.dart
part of 'login_view_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

// Initial state, also used for password visibility changes
class LoginInitial extends LoginState {
  final bool obscureText;

  const LoginInitial({this.obscureText = true});

  @override
  List<Object?> get props => [obscureText];
}

// State when the login process is running
class LoginLoading extends LoginState {}

// State when login is successful
class LoginSuccess extends LoginState {}

// State when login fails
class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}