import 'package:hive_flutter/adapters.dart';
import 'package:jeevandaan/features/auth/data/models/user_model.dart';

class UserLocalDataSource {
  final Box<UserModel> userBox;

  UserLocalDataSource(this.userBox);

  Future<void>addUser(UserModel user)async{
    await userBox.put(user.email, user);
  }
  UserModel?getUser(String email){
    return userBox.get(email);
  }
}