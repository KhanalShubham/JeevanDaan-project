import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, UserEntity>> updateUserDetails(UserEntity user);
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}