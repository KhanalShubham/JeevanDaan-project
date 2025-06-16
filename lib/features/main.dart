import 'package:flutter/material.dart';
import 'package:jeevandaan/app/app.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/core/network/hive_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveServices().init();
  await initDependencies();
  runApp(App());
}