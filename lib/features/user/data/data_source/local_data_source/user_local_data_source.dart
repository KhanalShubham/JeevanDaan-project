import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/user/data/data_source/user_data_source.dart';
import 'package:jeevandaan/features/user/data/models/user_model.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource{
  final HiveServices _hiveServices;

  UserLocalDataSource({required HiveServices hiveservices}):_hiveServices=hiveservices;

  @override
  Future<String>login(String email, String password)async{
    try{
      final userdata=await _hiveServices.login(email, password);
      if(userdata!=null && userdata.password==password){
        return "login successfull";
      }else{
        throw Exception("Invalid username or password");
      }
    }catch(e){
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
}