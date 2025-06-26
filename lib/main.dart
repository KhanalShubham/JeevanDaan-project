import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/app/themes/themes.dart';
import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/splash/presentation/view/splash_view.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await HiveServices().init();

  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: ThemeConstant.primaryColor,
        appBarTheme: AppBarTheme(
          color: ThemeConstant.appBarColor,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: ThemeConstant.primaryColor,
          secondary: ThemeConstant.darkPrimaryColor,
        ),
      ),
      home: BlocProvider(
        create: (_) => serviceLocator<SplashViewModel>(),
        child: SplashView(),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}