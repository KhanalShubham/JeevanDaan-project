import 'package:dartz/dartz.dart';
import 'package:jeevandaan/app/use_case/usecase.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/setting/domain/repository/settings_repository.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class UpdateUserDetailsUseCase implements UsecaseWithParams<UserEntity, UserEntity> {
  final ISettingsRepository _repository;

  UpdateUserDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity params) async {
    return await _repository.updateUserDetails(params);
  }
}