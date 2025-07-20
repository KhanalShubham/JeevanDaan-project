import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

abstract interface class IUserDataSource{
  Future<void>registerUser(UserEntity userdata);
  Future<String>login(String email, String password);
  Future<UserEntity> getMe(String token);
  Future<UserEntity> updateMe(String token, {required String name, required String description, required String contact, required String disease});
  Future<void> changePassword(String token, {required String currentPassword, required String newPassword});
}