import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFormValid;
  final bool agreeToTerms;
  final String? selectedGender;
  final String? errorMessage;
  final List<String> genderOptions;

  const SignupState({
    required this.isLoading,
    required this.isSuccess,
    required this.isFormValid,
    required this.agreeToTerms,
    this.selectedGender,
    this.errorMessage,
    required this.genderOptions,
  });

  const SignupState.initial()
      : isLoading = false,
        isSuccess = false,
        isFormValid = false,
        agreeToTerms = false,
        selectedGender = null,
        errorMessage = null,
        genderOptions = const ['Male', 'Female', 'Others'];

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isFormValid,
    bool? agreeToTerms,
    String? selectedGender,
    String? errorMessage,
    List<String>? genderOptions,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFormValid: isFormValid ?? this.isFormValid,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      selectedGender: selectedGender ?? this.selectedGender,
      errorMessage: errorMessage ?? this.errorMessage,
      genderOptions: genderOptions ?? this.genderOptions,
    );
  }

  // Helper method to get appropriate icon based on selected gender
  IconData getGenderIcon() {
    switch (selectedGender) {
      case 'Male':
        return Icons.man;
      case 'Female':
        return Icons.woman;
      case 'Others':
        return Icons.transgender;
      default:
        return Icons.people;
    }
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        isFormValid,
        agreeToTerms,
        selectedGender,
        errorMessage,
        genderOptions,
      ];
}