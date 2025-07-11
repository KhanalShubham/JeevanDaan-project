import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/exceptions.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/dashboard/data/data_source/dashboard_remote_data_source.dart';
import 'package:jeevandaan/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class DashboardRepositoryImpl implements IDashboardRepository {
  final IDashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserDetails() async {
    try {
      // Attempt to get user details from the remote source.
      final userModel = await remoteDataSource.getUserDetails();
      // On success, convert the API model to an entity and return it on the Right side.
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      // If a ServerException occurs, return a ServerFailure on the Left side.
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<RequestEntity>>> getRecentRequests() async {
    try {
      // Attempt to get recent requests from the remote source.
      final requestModels = await remoteDataSource.getRecentRequests();
      // On success, convert the list of models to a list of entities and return it.
      return Right(requestModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // If a ServerException occurs, return a ServerFailure on the Left side.
      return Left(ServerFailure(message: e.message));
    }
  }
}