import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_user_details_usecase.dart';
import 'package:jeevandaan/features/setting/domain/use_case/update_user_details_use_case.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

// --- State ---
enum UpdateProfileStatus { loading, success, submitting, updateSuccess, failure }

class UpdateProfileState extends Equatable {
  final UpdateProfileStatus status;
  final UserEntity? user;
  final String? error;

  const UpdateProfileState({
    this.status = UpdateProfileStatus.loading,
    this.user,
    this.error,
  });

  UpdateProfileState copyWith({
    UpdateProfileStatus? status,
    UserEntity? user,
    String? error,
  }) {
    return UpdateProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}

// --- Event ---
abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();
  @override
  List<Object> get props => [];
}

class LoadProfile extends UpdateProfileEvent {}

class SubmitProfile extends UpdateProfileEvent {
  final UserEntity user;
  const SubmitProfile({required this.user});
  @override
  List<Object> get props => [user];
}

// --- ViewModel (Bloc) ---
class UpdateProfileViewModel extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final GetUserDetailsUseCase _getUserDetailsUseCase;
  final UpdateUserDetailsUseCase _updateUserDetailsUseCase;

  UpdateProfileViewModel({
    required GetUserDetailsUseCase getUserDetailsUseCase,
    required UpdateUserDetailsUseCase updateUserDetailsUseCase,
  })  : _getUserDetailsUseCase = getUserDetailsUseCase,
        _updateUserDetailsUseCase = updateUserDetailsUseCase,
        super(const UpdateProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<SubmitProfile>(_onSubmitProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<UpdateProfileState> emit) async {
    emit(state.copyWith(status: UpdateProfileStatus.loading));
    final result = await _getUserDetailsUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: UpdateProfileStatus.failure, error: failure.message)),
      (user) => emit(state.copyWith(status: UpdateProfileStatus.success, user: user)),
    );
  }

  Future<void> _onSubmitProfile(SubmitProfile event, Emitter<UpdateProfileState> emit) async {
    emit(state.copyWith(status: UpdateProfileStatus.submitting));
    final result = await _updateUserDetailsUseCase(event.user);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: UpdateProfileStatus.failure, error: failure.message)),
      (_) => emit(state.copyWith(status: UpdateProfileStatus.updateSuccess)),
    );
  }
}