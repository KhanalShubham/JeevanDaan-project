import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_register_use_case.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final UserRegisterUseCase _userRegisterUseCase;

  SignupViewModel(this._userRegisterUseCase)
      : super( SignupState.initial()) {
    on<SignupNextStepTapped>(_onNextStepTapped);
    on<SignupPreviousStepTapped>(_onPreviousStepTapped);
    on<SignupTermsToggled>(_onTermsToggled);
    on<SignupShowTermsTapped>(_onShowTermsTapped);
  }

  // All validation logic is now private to the ViewModel
  bool _isValidName(String name) => name.isNotEmpty;
  bool _isValidEmail(String email) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  bool _isValidContact(String contact) => RegExp(r'^[0-9]{6,15}$').hasMatch(contact);
  bool _isValidPassword(String password) => RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$').hasMatch(password);
  bool _isValidDisease(String disease) => disease.isNotEmpty;
  bool _isValidDescription(String description) => description.isNotEmpty;


  void _onNextStepTapped(SignupNextStepTapped event, Emitter<SignupState> emit) async {
    emit(state.copyWith(clearErrorMessage: true));
    
    switch (state.currentStep) {
      case 0:
        if (!_isValidName(event.name)) {
          emit(state.copyWith(errorMessage: 'Please enter your name'));
          return;
        }
        break;
      case 1:
        if (!_isValidEmail(event.email)) {
          emit(state.copyWith(errorMessage: 'Please enter a valid email'));
          return;
        }
        break;
      case 2:
        if (!_isValidPassword(event.password)) {
          emit(state.copyWith(errorMessage: 'Password must be 8+ chars & include uppercase, number, and symbol'));
          return;
        }
        break;
      case 3:
        if (!_isValidContact(event.contact)) {
          emit(state.copyWith(errorMessage: 'Please enter a valid contact number'));
          return;
        }
        break;
      case 4:
        if (!_isValidDisease(event.disease)) {
          emit(state.copyWith(errorMessage: 'Please enter your disease'));
          return;
        }
        break;
      case 5:
        if (!_isValidDescription(event.description)) {
          emit(state.copyWith(errorMessage: 'Please enter a description'));
          return;
        }
        break;
      case 6:
        if (!state.agreeToTerms) {
          emit(state.copyWith(errorMessage: 'You must agree to the terms to continue'));
          return;
        }
        await _submitRegistration(event, emit);
        return;
    }
    
    if (state.currentStep < 6) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  Future<void> _submitRegistration(SignupNextStepTapped event, Emitter<SignupState> emit) async {
    emit(state.copyWith(isLoading: true));

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
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
    );
  }

  void _onPreviousStepTapped(SignupPreviousStepTapped event, Emitter<SignupState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1, clearErrorMessage: true));
    } else {
      emit(state.copyWith(shouldPop: true));
    }
  }
  
  void _onShowTermsTapped(SignupShowTermsTapped event, Emitter<SignupState> emit) {
    emit(state.copyWith(showDialog: true, dialogType: event.type));
  }

  void _onTermsToggled(SignupTermsToggled event, Emitter<SignupState> emit) {
    emit(state.copyWith(agreeToTerms: event.hasAgreed));
  }
}