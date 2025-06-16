import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveServices {
  Future <void> init()async{

    var directory = await getApplicationDocumentsDirectory();
    var path='${directory.path}/jeevandaan.db';
    Hive.init(path);
  }

  
  // Future<UserHiveModel?>Login(String email, String password)async{
  //   var box=await Hive.openBox<UserHiveModel>(
  //     HiveTableConstant.userBoxName,
  //   );
  //   var user= box.values.firstWhere(
  //     (element)=>element.email==email && element.password==password,
  //     orElse: ()=>throw Exception("invalid username or password"),
  //   );
  //   box.close();
  //   return user;
  // }

  static Future<Box>openBox(String userBoxName)async{
    return await Hive.openBox(userBoxName);
  }
}