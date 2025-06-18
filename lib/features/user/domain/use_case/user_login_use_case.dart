
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jeevandaan/app/use_case/usecase.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  // Initial Constructor
  const LoginParams.initial() : email = '', password = '';
  @override
  List<Object?> get props => [email, password];
}

class UserLoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IUserRepository _userRepository;

  UserLoginUseCase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await _userRepository.login(
      params.email,
      params.password,
    );
  }
}