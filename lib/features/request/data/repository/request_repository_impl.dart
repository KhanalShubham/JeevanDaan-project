import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/exceptions.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/request/data/data_source/request_remote_data_source.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'dart:io';

class RequestRepositoryImpl implements IRequestRepository {
  final IRequestRemoteDataSource remoteDataSource;

  RequestRepositoryImpl({required this.remoteDataSource});

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
  }

  @override
  Future<Either<Failure, List<RequestEntity>>> getMyRequests() async {
    try {
      final requests = await remoteDataSource.getMyRequests();
      return Right(requests);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRequest(String requestId) async {
    try {
      await remoteDataSource.deleteRequest(requestId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}