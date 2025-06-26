import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_register_use_case.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final UserRegisterUseCase _userRegisterUseCase;

  SignupViewModel({required IUserRepository userRepository})
      : _userRegisterUseCase = UserRegisterUseCase(userRepository: userRepository),
        super(const SignupState.initial()) {
    on<NavigateBackEvent>(_onNavigateBack);
    on<SignupWithCredentialsEvent>(_onSignupWithCredentials);
    on<ToggleTermsAgreementEvent>(_onToggleTermsAgreement);
    on<ValidateFormEvent>(_onValidateForm);
    on<ShowTermsEvent>(_onShowTerms);
  }

  void _onNavigateBack(NavigateBackEvent event, Emitter<SignupState> emit) {
    if (event.context.mounted) {
      Navigator.pop(event.context);
    }
  }

  void _onSignupWithCredentials(
      SignupWithCredentialsEvent event, Emitter<SignupState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await _userRegisterUseCase(
        RegisterUserParams(
          name: event.name,
          email: event.email,
          contact: event.contact,
          password: event.password,
          disease: event.disease,
          description: event.description,
        ),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: failure.message,
          ));
          if (event.context.mounted) {
            ScaffoldMessenger.of(event.context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (_) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
          if (event.context.mounted) {
            ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(content: Text("Sign up successful!")),
            );
            Navigator.pop(event.context);
          }
        },
      );
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

  void _onToggleTermsAgreement(ToggleTermsAgreementEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(agreeToTerms: event.agreed));
    add(ValidateFormEvent());
  }

  void _onValidateForm(ValidateFormEvent event, Emitter<SignupState> emit) {
    bool isValid = state.agreeToTerms;
    emit(state.copyWith(isFormValid: isValid));
  }

  void _onShowTerms(ShowTermsEvent event, Emitter<SignupState> emit) {
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

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidContact(String contact) {
    return RegExp(r'^[0-9]{6,15}$').hasMatch(contact);
  }

  bool isValidPasswordRegEx(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
        .hasMatch(password);
  }
}