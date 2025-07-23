import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_register_use_case.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  test('calls registerUser on repository with correct user entity', () async {
    final repo = MockUserRepository();
    final usecase = UserRegisterUseCase(userRepository: repo);
    final params = RegisterUserParams(
      name: 'Test',
      email: 'test@example.com',
      contact: '1234567890',
      disease: 'None',
      description: 'desc',
      password: 'password',
    );
    final userEntity = UserEntity(
      name: 'Test',
      email: 'test@example.com',
      disease: 'None',
      contact: '1234567890',
      description: 'desc',
      password: 'password',
    );
    when(() => repo.registerUser(userEntity)).thenAnswer((_) async => const Right(null));
    await usecase(params);
    verify(() => repo.registerUser(userEntity)).called(1);
  });
}