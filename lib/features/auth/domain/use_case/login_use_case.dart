import 'package:jeevandaan/features/auth/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/auth/domain/repository/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;
  LoginUseCase(this.repository);

  Future<void>execute(UserEntity user)async{
    await repository.Login(user);
  }
}