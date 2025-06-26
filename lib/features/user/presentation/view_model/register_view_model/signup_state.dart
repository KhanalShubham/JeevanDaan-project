import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFormValid;
  final bool agreeToTerms;
  final String? errorMessage;

  const SignupState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFormValid = false,
    this.agreeToTerms = false,
    this.errorMessage,
  });

  const SignupState.initial()
      : isLoading = false,
        isSuccess = false,
        isFormValid = false,
        agreeToTerms = false,
        errorMessage = null;

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isFormValid,
    bool? agreeToTerms,
    String? errorMessage,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFormValid: isFormValid ?? this.isFormValid,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        isFormValid,
        agreeToTerms,
        errorMessage,
      ];
}