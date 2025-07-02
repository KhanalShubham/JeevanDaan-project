import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/data/data_source/remote_data_source/user_remote_datasource.dart';
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
}