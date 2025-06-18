import 'package:get_it/get_it.dart';
import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:jeevandaan/features/user/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:jeevandaan/features/user/data/repository/local_repository/user_local_repository_impl.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_register_use_case.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initHiveService();
  await _initSplashModule();
  await _initBoardingScreen();
  await _initUserModule();
}
Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveServices());
}
Future _initSplashModule() async {
  // Register Splash ViewModel
  serviceLocator.registerFactory<SplashViewModel>(() => SplashViewModel());
  
  // Register other dependencies as needed
  // Example: serviceLocator.registerLazySingleton<SomeService>(() => SomeServiceImpl());
}
Future _initBoardingScreen() async{
  serviceLocator.registerFactory<BoardingViewModel>(()=>BoardingViewModel());
}
Future<void> _initUserModule()async{
  serviceLocator.registerFactory(
    ()=>UserLocalDataSource(hiveservices: serviceLocator<HiveServices>())
  );
  serviceLocator.registerFactory(
    ()=>UserLocalRepositoryImpl(userLocalDataSource: serviceLocator<UserLocalDataSource>(),)
  );
  serviceLocator.registerFactory(
    ()=>UserRegisterUseCase(userRepository: serviceLocator<UserLocalRepositoryImpl>()),
  );
  serviceLocator.registerFactory(
    ()=>LoginViewModel(),
  );
}

