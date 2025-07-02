import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final int currentStep;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final bool agreeToTerms;

  // These flags are for one-time events handled by the listener
  final bool shouldPop;
  final bool showDialog;
  final String? dialogType; // e.g., 'terms' or 'privacy'

  const SignupState({
    this.currentStep = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.agreeToTerms = false,
    this.shouldPop = false,
    this.showDialog = false,
    this.dialogType,
  });

  factory SignupState.initial() => const SignupState();

  SignupState copyWith({
    int? currentStep,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool? agreeToTerms,
    bool? clearErrorMessage, // Special flag to nullify error
    bool? shouldPop,
    bool? showDialog,
    String? dialogType,
  }) {
    return SignupState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearErrorMessage == true ? null : errorMessage ?? this.errorMessage,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      shouldPop: shouldPop ?? false,
      showDialog: showDialog ?? false,
      dialogType: dialogType ?? this.dialogType,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        isLoading,
        isSuccess,
        errorMessage,
        agreeToTerms,
        shouldPop,
        showDialog,
        dialogType,
      ];
}