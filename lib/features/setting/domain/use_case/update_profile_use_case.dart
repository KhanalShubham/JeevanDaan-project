import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/setting/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/setting/domain/repository/user_repository.dart';

class UpdateProfileUseCase {
  final IUserRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String token, {required String name, required String description, required String contact, required String disease}) {
    return repository.updateMe(token, name: name, description: description, contact: contact, disease: disease);
  }
} 