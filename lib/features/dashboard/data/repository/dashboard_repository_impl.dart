import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/exceptions.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/dashboard/data/data_source/dashboard_remote_data_source.dart';
import 'package:jeevandaan/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:flutter/foundation.dart';

class DashboardRepositoryImpl implements IDashboardRepository {
  final IDashboardRemoteDataSource remoteDataSource;
  final IDashboardRemoteDataSource? localDataSource;
  final ConnectivityService _connectivityService = ConnectivityService();

  DashboardRepositoryImpl({required this.remoteDataSource, this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserDetails() async {
    final online = await _connectivityService.isOnline;
    if (online) {
      try {
        final userModel = await remoteDataSource.getUserDetails();
        return Right(userModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else if (localDataSource != null) {
      debugPrint('[OFFLINE] Using local data source for getUserDetails');
      // Implement local getUserDetails logic if available
      return Left(RemoteDatabaseFailure(message: 'Local getUserDetails not implemented.'));
    } else {
      return Left(RemoteDatabaseFailure(message: 'No internet and no local data source available.'));
    }
  }

  @override
  Future<Either<Failure, List<RequestEntity>>> getRecentRequests() async {
    final online = await _connectivityService.isOnline;
    if (online) {
      try {
        final requestModels = await remoteDataSource.getRecentRequests();
        return Right(requestModels.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else if (localDataSource != null) {
      debugPrint('[OFFLINE] Using local data source for getRecentRequests');
      // Implement local getRecentRequests logic if available
      return Left(RemoteDatabaseFailure(message: 'Local getRecentRequests not implemented.'));
    } else {
      return Left(RemoteDatabaseFailure(message: 'No internet and no local data source available.'));
    }
  }
}