import 'package:jeevandaan/features/auth/domain/entity/user_entity.dart';

abstract class UserRepository {
  // ignore: non_constant_identifier_names
  Future<void>Login(UserEntity user);
  UserEntity?getUser(String email);
}