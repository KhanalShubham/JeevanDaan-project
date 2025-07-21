import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/exceptions.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/request/data/data_source/request_remote_data_source.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'dart:io';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:flutter/foundation.dart';

class RequestRepositoryImpl implements IRequestRepository {
  final IRequestRemoteDataSource remoteDataSource;
  final IRequestRemoteDataSource? localDataSource;
  final ConnectivityService _connectivityService = ConnectivityService();

  RequestRepositoryImpl({required this.remoteDataSource, this.localDataSource});

  @override
  Future<Either<Failure, void>> addRequest(
    String description,
    num neededAmount,
    String condition,
    String inDepthStory,
    String citizen,
    File supportingDoc,
    File userImage,
    File citizenshipImage,
  ) async {
    final online = await _connectivityService.isOnline;
    if (online) {
      try {
        await remoteDataSource.addRequest(
          description,
          neededAmount,
          condition,
          inDepthStory,
          citizen,
          supportingDoc,
          userImage,
          citizenshipImage,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    } else if (localDataSource != null) {
      debugPrint('[OFFLINE] Using local data source for addRequest');
      // Implement local addRequest logic if available
      return Left(RemoteDatabaseFailure(message: 'Local addRequest not implemented.'));
    } else {
      return Left(RemoteDatabaseFailure(message: 'No internet and no local data source available.'));
    }
  }

  @override
  Future<Either<Failure, List<RequestEntity>>> getMyRequests() async {
    final online = await _connectivityService.isOnline;
    if (online) {
      try {
        final requests = await remoteDataSource.getMyRequests();
        return Right(requests);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    } else if (localDataSource != null) {
      debugPrint('[OFFLINE] Using local data source for getMyRequests');
      // Implement local getMyRequests logic if available
      return Left(RemoteDatabaseFailure(message: 'Local getMyRequests not implemented.'));
    } else {
      return Left(RemoteDatabaseFailure(message: 'No internet and no local data source available.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRequest(String requestId) async {
    final online = await _connectivityService.isOnline;
    if (online) {
      try {
        await remoteDataSource.deleteRequest(requestId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    } else if (localDataSource != null) {
      debugPrint('[OFFLINE] Using local data source for deleteRequest');
      // Implement local deleteRequest logic if available
      return Left(RemoteDatabaseFailure(message: 'Local deleteRequest not implemented.'));
    } else {
      return Left(RemoteDatabaseFailure(message: 'No internet and no local data source available.'));
    }
  }
}