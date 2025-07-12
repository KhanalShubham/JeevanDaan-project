// features/dashboard/domain/repository/dashboard_repository.dart

import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

abstract class IDashboardRepository {
  Future<Either<Failure, UserEntity>> getUserDetails();
  Future<Either<Failure, List<RequestEntity>>> getRecentRequests();
}