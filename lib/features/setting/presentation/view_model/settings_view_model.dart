import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_user_details_usecase.dart';
import 'package:jeevandaan/features/setting/domain/use_case/logout_use_case.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

// --- State ---
enum SettingsStatus { initial, loading, success, failure, loggedOut }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final UserEntity? user;
  final String? error;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.user,
    this.error,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    UserEntity? user,
    String? error,
  }) {
    return SettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}

// --- Event ---
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadUserDetails extends SettingsEvent {}
class LogoutRequested extends SettingsEvent {}

// --- ViewModel (Bloc) ---
class SettingsViewModel extends Bloc<SettingsEvent, SettingsState> {
  final LogoutUseCase _logoutUseCase;
  final GetUserDetailsUseCase _getUserDetailsUseCase;

  SettingsViewModel({
    required LogoutUseCase logoutUseCase,
    required GetUserDetailsUseCase getUserDetailsUseCase,
  })  : _logoutUseCase = logoutUseCase,
        _getUserDetailsUseCase = getUserDetailsUseCase,
        super(const SettingsState()) {
    on<LoadUserDetails>(_onLoadUserDetails);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadUserDetails(LoadUserDetails event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    final result = await _getUserDetailsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: SettingsStatus.failure, error: failure.message)),
      (user) => emit(state.copyWith(status: SettingsStatus.success, user: user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<SettingsState> emit) async {
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: SettingsStatus.failure, error: failure.message)),
      (_) => emit(state.copyWith(status: SettingsStatus.loggedOut)),
    );
  }
}