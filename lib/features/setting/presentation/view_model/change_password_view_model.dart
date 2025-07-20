import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/setting/domain/use_case/change_password_use_case.dart';

enum ChangePasswordStatus { initial, submitting, success, failure }

class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;
  final String? error;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.error,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? error,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
  @override
  List<Object> get props => [];
}

class PasswordChangeSubmitted extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;

  const PasswordChangeSubmitted({required this.currentPassword, required this.newPassword});
}

class ChangePasswordViewModel extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordViewModel({required ChangePasswordUseCase changePasswordUseCase})
      : _changePasswordUseCase = changePasswordUseCase,
        super(const ChangePasswordState()) {
    on<PasswordChangeSubmitted>(_onPasswordChangeSubmitted);
  }

  Future<void> _onPasswordChangeSubmitted(
    PasswordChangeSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(status: ChangePasswordStatus.submitting));
    final result = await _changePasswordUseCase(
      ChangePasswordParams(currentPassword: event.currentPassword, newPassword: event.newPassword),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: ChangePasswordStatus.failure, error: failure.message)),
      (_) => emit(state.copyWith(status: ChangePasswordStatus.success)),
    );
  }
}