import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveServices {
  Future <void> init()async{

    var directory = await getApplicationDocumentsDirectory();
    var path='${directory.path}/jeevandaan.db';
    Hive.init(path);
  }
}