import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';

class GetProfileUseCase {
  final IUserRepository repository;
  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String token) {
    return repository.getMe(token);
  }
} 