import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/setting/data/data_source/settings_remote_data_source.dart';
import 'package:jeevandaan/features/setting/domain/repository/settings_repository.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final ISettingsRemoteDataSource _remoteDataSource;

  SettingsRepositoryImpl({required ISettingsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> updateUserDetails(UserEntity user) async {
    try {
      final updatedUserModel = await _remoteDataSource.updateUserDetails(user);
      return Right(updatedUserModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}