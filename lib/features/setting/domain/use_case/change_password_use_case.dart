import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/setting/domain/repository/user_repository.dart';

class ChangePasswordUseCase {
  final IUserRepository repository;
  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String token, {required String currentPassword, required String newPassword}) {
    return repository.changePassword(token, currentPassword: currentPassword, newPassword: newPassword);
  }
} 