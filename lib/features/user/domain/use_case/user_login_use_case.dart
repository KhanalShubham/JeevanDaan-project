import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';


class UserLoginUseCase {
  final IUserRepository userRepository;

  UserLoginUseCase({required this.userRepository});

  Future<Either<Failure, void>> call(LoginUserParams params) async {
    return await userRepository.login(params.email, params.password);
  }
}

class LoginUserParams {
  final String email;
  final String password;

  LoginUserParams({required this.email, required this.password});
}