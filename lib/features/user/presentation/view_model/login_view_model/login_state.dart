import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool obscureText;
  final String? errorMessage;

  const LoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.obscureText = true,
    this.errorMessage,
  });

  const LoginState.initial()
      : isLoading = false,
        isSuccess = false,
        obscureText = true,
        errorMessage = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? obscureText,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      obscureText: obscureText ?? this.obscureText,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, obscureText, errorMessage];
}