import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/user/data/data_source/user_data_source.dart';
import 'package:jeevandaan/features/user/data/models/user_model.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/entity/login_response.dart';

class UserLocalDataSource implements IUserDataSource{
  final HiveServices _hiveServices;

  UserLocalDataSource({required HiveServices hiveservices}):_hiveServices=hiveservices;

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final userdata = await _hiveServices.login(email, password);
      if (userdata.password == password) {
        // Use a dummy token for local login, and return the user's role
        return LoginResponse(token: 'local_dummy_token', role: userdata.role);
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
  
  @override
  Future<void> registerUser(UserEntity userdata) async {
    try{
      final userModel=UserModel.fromEntity(userdata);
      await _hiveServices.register(userModel);
    }catch(e){
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<UserEntity> getMe(String token) async {
    // Implement your local user fetch logic here if needed
    throw UnimplementedError('Local getMe not implemented');
  }
}