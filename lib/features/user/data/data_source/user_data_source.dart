import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

abstract interface class IUserDataSource{
  Future<void>registerUser(UserEntity userdata);
  Future<String>login(String email, String password);
  Future<UserEntity> getMe(String token);
}