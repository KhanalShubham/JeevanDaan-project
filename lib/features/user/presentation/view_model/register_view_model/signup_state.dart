import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final bool agreeToTerms;
  final int currentStep; // ADDED: To manage the stepper UI

  const SignupState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    required this.agreeToTerms,
    required this.currentStep,
  });

  // The initial state of the screen
  const SignupState.initial()
      : isLoading = false,
        isSuccess = false,
        errorMessage = null,
        agreeToTerms = false,
        currentStep = 0; // Starts at the first step

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool? agreeToTerms,
    int? currentStep,
    bool clearErrorMessage = false, // Helper to clear old errors
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        errorMessage,
        agreeToTerms,
        currentStep,
      ];
}