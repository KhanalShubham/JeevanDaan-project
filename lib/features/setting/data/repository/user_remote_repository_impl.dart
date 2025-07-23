import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/setting/data/data_source/user_remote_datasource.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';

class UserRemoteRepositoryImpl implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepositoryImpl({
    required UserRemoteDatasource userRemoteDatasource,
  }) : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, String>> login(
    String email,
    String password,
  ) async {
    try {
      final token = await _userRemoteDatasource.login(email, password);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  // in UserRemoteRepositoryImpl

@override
Future<Either<Failure, void>> registerUser(UserEntity user) async {
  try {
    await _userRemoteDatasource.registerUser(user);
    return const Right(null);
  } catch (e) {
    // e.toString() often includes "Exception: ". We can clean it up.
    final errorMessage = e.toString().replaceFirst('Exception: ', '');
    return Left(RemoteDatabaseFailure(message: errorMessage));
  }
}

  @override
  Future<Either<Failure, UserEntity>> getMe(String token) async {
    try {
      final user = await _userRemoteDatasource.getMe(token);
      return Right(user);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateMe(String token, {required String name, required String description, required String contact, required String disease, String? photoUrl}) async {
    try {
      final user = await _userRemoteDatasource.updateMe(token, name: name, description: description, contact: contact, disease: disease, photoUrl: photoUrl);
      return Right(user);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(String token, {required String currentPassword, required String newPassword}) async {
    try {
      await _userRemoteDatasource.changePassword(token, currentPassword: currentPassword, newPassword: newPassword);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}