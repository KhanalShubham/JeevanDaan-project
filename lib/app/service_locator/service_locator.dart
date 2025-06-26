

import 'package:get_it/get_it.dart';
import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:jeevandaan/features/user/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:jeevandaan/features/user/data/repository/local_repository/user_local_repository_impl.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_register_use_case.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initSplashModule();
  await _initBoardingScreen();
  await _initUserModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveServices());
}

Future<void> _initSplashModule() async {
  // Register Splash ViewModel
  serviceLocator.registerFactory<SplashViewModel>(() => SplashViewModel());
}

Future<void> _initBoardingScreen() async {
  serviceLocator.registerFactory<BoardingViewModel>(() => BoardingViewModel());
}

Future<void> _initUserModule() async {
  // Register UserLocalDataSource
  serviceLocator.registerFactory<UserLocalDataSource>(
    () => UserLocalDataSource(hiveservices: serviceLocator<HiveServices>()),
  );

  // Register IUserRepository
  serviceLocator.registerFactory<IUserRepository>(
    () => UserLocalRepositoryImpl(userLocalDataSource: serviceLocator<UserLocalDataSource>()),
  );

  // Register UserRegisterUseCase
  serviceLocator.registerFactory<UserRegisterUseCase>(
    () => UserRegisterUseCase(userRepository: serviceLocator<IUserRepository>()),
  );

  // Register LoginViewModel (optionally with IUserRepository if needed)
  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(userRepository: serviceLocator<IUserRepository>()),
  );
}
