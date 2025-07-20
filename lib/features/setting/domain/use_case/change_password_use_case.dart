
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jeevandaan/app/use_case/usecase.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/setting/domain/repository/settings_repository.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({required this.currentPassword, required this.newPassword});

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class ChangePasswordUseCase implements UsecaseWithParams<void, ChangePasswordParams> {
  final ISettingsRepository _repository;

  ChangePasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}
