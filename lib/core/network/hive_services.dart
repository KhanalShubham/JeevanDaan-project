import 'package:hive_flutter/adapters.dart';
import 'package:jeevandaan/app/constant/hive/hive_table_constant.dart';
import 'package:jeevandaan/features/user/data/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveServices {
  Future <void> init()async{

    var directory = await getApplicationDocumentsDirectory();
    var path='${directory.path}/jeevandaan.db';
    Hive.init(path);

    Hive.registerAdapter(UserModelAdapter());
  }
  Future<void>register(UserModel auth)async{
    var box=await Hive.openBox<UserModel>(
      HiveTableConstant.userBoxName,
    );
    await box.put(auth.userId, auth);
  }
  Future<UserModel>login(String email, String password)async{
    var box=await Hive.openBox<UserModel>(
      HiveTableConstant.userBoxName,
    );
    var user=box.values.firstWhere(
      (element)=>element.email==email && element.password==password,
      orElse: ()=>throw Exception("Invalid email or password"),
    );
    box.close();
    return user;
  }
  Future<void>close()async{
    await Hive.close();
  }
  
}