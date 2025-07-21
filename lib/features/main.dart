import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jeevandaan/app/app.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/mainnavigation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveServices().init();
  await initDependencies(); // Ensure dependencies are registered
  final box = await Hive.openBox('userBox');
  for (var user in box.values) {
    debugPrint(user.toString());
  }
  final prefs = await SharedPreferences.getInstance();
  final timestamp = prefs.getInt('last_login_timestamp');
  bool isLoginValid = false;
  if (timestamp != null) {
    final lastLogin = DateTime.fromMillisecondsSinceEpoch(timestamp);
    isLoginValid = DateTime.now().difference(lastLogin) < Duration(days: 1);
    if (!isLoginValid) {
      await prefs.remove('last_login_timestamp');
      // Optionally clear other credentials here
    }
  }
  runApp(App(initialRoute: isLoginValid ? 'dashboard' : 'login'));
}