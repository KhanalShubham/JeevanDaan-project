import 'package:jeevandaan/features/user/domain/entity/login_response.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/data/data_source/remote_data_source/user_remote_datasource.dart';

abstract interface class IUserDataSource{
  Future<void>registerUser(UserEntity userdata);
  Future<LoginResponse> login(String email, String password);
  Future<UserEntity> getMe(String token);
}