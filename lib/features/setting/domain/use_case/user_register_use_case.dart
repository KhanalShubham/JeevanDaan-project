// features/user/domain/use_case/user_register_use_case.dart (Revised)

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; // Keep Equatable here for RegisterUserParams
import 'package:jeevandaan/app/use_case/usecase.dart'; // Updated import for the fixed UsecaseWithParams
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';

// RegisterUserParams can still extend Equatable
class RegisterUserParams extends Equatable {
  final String name;
  final String email;
  final String contact;
  final String disease;
  final String description;
  final String password;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.contact,
    required this.disease,
    required this.description,
    required this.password
  });

  // Keep the initial constructor as is
  const RegisterUserParams.initial({
    required this.name,
    required this.email,
    required this.contact,
    required this.disease,
    required this.description,
    required this.password
  });

  @override
  List<Object?> get props => [
    name,
    email,
    contact,
    disease,
    description,
    password,
  ];
}

// Now this correctly implements UsecaseWithParams.
class UserRegisterUseCase implements UsecaseWithParams<void, RegisterUserParams> {
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
      password: params.password, role: 'user',
    );
    return _userRepository.registerUser(userEntity);
  }
}