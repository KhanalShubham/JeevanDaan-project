// features/dashboard/domain/usecase/get_recent_requests_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:jeevandaan/app/use_case/usecase.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';

class GetRecentRequestsUseCase implements Usecase<List<RequestEntity>> {
  final IDashboardRepository repository;

  GetRecentRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<RequestEntity>>> call() async {
    return await repository.getRecentRequests();
  }
}