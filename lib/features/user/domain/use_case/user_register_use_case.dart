

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jeevandaan/app/use_case/usecase.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String name;
  final String email;
  final String disease;
  final String contact;
  final String description;
  final String password;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.disease,
    required this.contact,
    required this.description,
    required this.password
  });

  //intial constructor
  const RegisterUserParams.initial({
    required this.name,
    required this.email,
    required this.disease,
    required this.contact,
    required this.description,
    required this.password,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    disease,
    contact,
    description,
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
      name: params.name,
      email: params.email,
      disease: params.disease,
      contact: params.contact,
      description: params.description,
      password: params.password, userId: '',
    );
    return _userRepository.registerUser(userEntity);
  }
}