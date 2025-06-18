

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jeevandaan/app/use_case/usecase.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String email;
  final String phone;
  final String gender;
  final String password;

  const RegisterUserParams({
    required this.email,
    required this.phone,
    required this.gender,
    required this.password
  });

  //intial constructor
  const RegisterUserParams.initial({
    required this.email,
    required this.phone,
    required this.gender,
    required this.password,
  });

  @override
  List<Object?> get props => [
    email,
    phone,
    gender,
    password,
  ];
}

class UserRegisterUseCase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUseCase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      email: params.email,
      phone: params.phone,
      gender: params.gender,
      password: params.password, userId: '',
    );
    return _userRepository.registerUser(userEntity);
  }
}