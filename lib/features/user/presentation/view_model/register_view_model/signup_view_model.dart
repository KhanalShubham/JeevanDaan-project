import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';
// Import your required dependencies
// import 'package:your_app/core/usecases/signup_usecase.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  // Uncomment and inject your use case when ready
  // final SignupUsecase _signupUsecase;

  SignupViewModel(
    // this._signupUsecase
  ) : super(const SignupState.initial()) {
    on<NavigateBackEvent>(_onNavigateBack);
    on<SignupWithCredentialsEvent>(_onSignupWithCredentials);
    on<UpdateGenderEvent>(_onUpdateGender);
    on<ToggleTermsAgreementEvent>(_onToggleTermsAgreement);
    on<ValidateFormEvent>(_onValidateForm);
    on<SocialSignupEvent>(_onSocialSignup);
    on<ShowTermsEvent>(_onShowTerms);
  }

  void _onNavigateBack(
    NavigateBackEvent event,
    Emitter<SignupState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pop(event.context);
    }
  }

  void _onSignupWithCredentials(
    SignupWithCredentialsEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Replace this with your actual signup logic
      // final result = await _signupUsecase(
      //   SignupParams(
      //     name: event.name,
      //     email: event.email,
      //     phone: event.phone,
      //     gender: event.gender,
      //   ),
      // );

      // Simulate API call for now
      await Future.delayed(const Duration(seconds: 2));

      // Mock success - replace with actual result handling
      // result.fold(
      //   (failure) {
      //     emit(state.copyWith(
      //       isLoading: false,
      //       isSuccess: false,
      //       errorMessage: failure.message,
      //     ));
      //     
      //     if (event.context.mounted) {
      //       ScaffoldMessenger.of(event.context).showSnackBar(
      //         SnackBar(
      //           content: Text(failure.message),
      //           backgroundColor: Colors.red,
      //         ),
      //       );
      //     }
      //   },
      //   (success) {
      //     emit(state.copyWith(isLoading: false, isSuccess: true));
      //     
      //     if (event.context.mounted) {
      //       ScaffoldMessenger.of(event.context).showSnackBar(
      //         const SnackBar(content: Text("Sign up successful!")),
      //       );
      //       Navigator.pop(event.context);
      //     }
      //   },
      // );

      // Mock implementation
      emit(state.copyWith(isLoading: false, isSuccess: true));
      
      if (event.context.mounted) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          const SnackBar(content: Text("Sign up successful!")),
        );
        Navigator.pop(event.context);
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      ));
      
      if (event.context.mounted) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text("Signup failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onUpdateGender(
    UpdateGenderEvent event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(selectedGender: event.gender));
    add(ValidateFormEvent());
  }

  void _onToggleTermsAgreement(
    ToggleTermsAgreementEvent event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(agreeToTerms: event.agreed));
    add(ValidateFormEvent());
  }

  void _onValidateForm(
    ValidateFormEvent event,
    Emitter<SignupState> emit,
  ) {
    // Form validation logic will be handled in the UI layer
    // This event can be used to trigger validation checks
    bool isValid = state.agreeToTerms && state.selectedGender != null;
    emit(state.copyWith(isFormValid: isValid));
  }

  void _onSocialSignup(
    SocialSignupEvent event,
    Emitter<SignupState> emit,
  ) {
    // Handle social signup logic
    if (event.context.mounted) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text("${event.provider} sign up tapped")),
      );
    }
  }

  void _onShowTerms(
    ShowTermsEvent event,
    Emitter<SignupState> emit,
  ) {
    // Handle showing terms and conditions or privacy policy
    if (event.context.mounted) {
      showDialog(
        context: event.context,
        builder: (context) => AlertDialog(
          title: Text(event.type == 'terms' ? 'Terms of Service' : 'Privacy Policy'),
          content: Text(
            event.type == 'terms'
                ? 'Terms of service content goes here...'
                : 'Privacy policy content goes here...',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  // Validation helper methods
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{6,15}$').hasMatch(phone);
  }
  bool isValidPasswordRegEx(String password) {
  // Minimum 8 characters, at least one uppercase, one lowercase, one digit, and one special character
  return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
      .hasMatch(password);
}
}