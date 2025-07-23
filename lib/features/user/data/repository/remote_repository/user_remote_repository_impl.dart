import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/data/data_source/remote_data_source/user_remote_datasource.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:jeevandaan/features/user/data/repository/local_repository/user_local_repository_impl.dart';

class UserRemoteRepositoryImpl implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;
  final UserLocalRepositoryImpl? _userLocalRepository;
  final ConnectivityService _connectivityService = ConnectivityService();

  UserRemoteRepositoryImpl({
    required UserRemoteDatasource userRemoteDatasource,
    UserLocalRepositoryImpl? userLocalRepository,
  })  : _userRemoteDatasource = userRemoteDatasource,
        _userLocalRepository = userLocalRepository;

  @override
  Future<Either<Failure, String>> login(
    String email,
    String password,
  ) async {
    final online = await _connectivityService.isOnline;
    if (online) {
      try {
        final token = await _userRemoteDatasource.login(email, password);
        return Right(token);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    } else if (_userLocalRepository != null) {
      debugPrint('[OFFLINE] Using local data source for login');
      return _userLocalRepository!.login(email, password);
    } else {
      return Left(RemoteDatabaseFailure(message: 'No internet and no local data source available.'));
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
  Future<Either<Failure, UserEntity>> updateMe(
    String token, {
      required String name,
      required String description,
      required String contact,
      required String disease,
      String? photoUrl,
    }
  ) async {
    try {
      final user = await _userRemoteDatasource.updateMe(
        token,
        name: name,
        description: description,
        contact: contact,
        disease: disease,
        photoUrl: photoUrl,
      );
      return Right(user);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}