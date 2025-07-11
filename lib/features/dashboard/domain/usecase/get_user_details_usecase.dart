// features/dashboard/domain/usecase/get_user_details_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:jeevandaan/app/use_case/usecase.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class GetUserDetailsUseCase implements Usecase<UserEntity> {
  final IDashboardRepository repository;

  GetUserDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getUserDetails();
  }
}