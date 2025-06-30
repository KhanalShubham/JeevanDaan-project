import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_view_model.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:jeevandaan/features/user/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:jeevandaan/features/user/data/data_source/remote_data_source/user_remote_datasource.dart';
import 'package:jeevandaan/features/user/data/repository/local_repository/user_local_repository_impl.dart';
import 'package:jeevandaan/features/user/data/repository/remote_repository/user_remote_repository_impl.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_login_use_case.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_register_use_case.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  // The order of initialization matters.
  // Register dependencies first, then the classes that use them.
  await _initHiveServices();
  await _initUserModule();
  await _initApiServices();
  await _initSharedPref();
  await _initGeneralViewModels();
  await _initMainNavigationModule();
}
Future<void> _initHiveServices() async{
  serviceLocator.registerLazySingleton(()=>HiveServices());
}
Future<void> _initApiServices()async{
  serviceLocator.registerLazySingleton(()=>ApiService(Dio()));
}
Future<void> _initSharedPref() async{
  final sharedPref=await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(()=>sharedPref);
  serviceLocator.registerLazySingleton(
    ()=>TokenSharedPrefs(sharedPreferences: serviceLocator<SharedPreferences>(),)
  );
}

Future<void> _initMainNavigationModule() async {
  serviceLocator.registerFactory(
    () => MainNavigationViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

Future<void> _initUserModule() async {
  // Data Sources
  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveservices: serviceLocator<HiveServices>()),
  );

  // Repository
  // Register the implementation (UserRemoteRepositoryImpl)
  // but as its abstract type (IUserRepository).
  serviceLocator.registerFactory(
    ()=>UserLocalRepositoryImpl(userLocalDataSource: serviceLocator<UserLocalDataSource>(),)
  );


  serviceLocator.registerFactory<IUserRepository>(
    () => UserRemoteRepositoryImpl(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // Usecases
  // The UseCases can correctly ask for an `IUserRepository`
  // and GetIt will provide the `UserRemoteRepositoryImpl` we registered above.
  serviceLocator.registerFactory(
    () => UserLoginUseCase(
      userRepository: serviceLocator<IUserRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserRegisterUseCase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  // --- User-specific ViewModels ---
  serviceLocator.registerFactory(
    () => LoginViewModel(
      serviceLocator<UserLoginUseCase>()
    ),
  );

  // ADDED: The missing registration for SignupViewModel.
  // This is the final step to make the signup flow work correctly.
  serviceLocator.registerFactory(
    () => SignupViewModel(
      serviceLocator<UserRegisterUseCase>(),
    ),
  );
}

Future _initGeneralViewModels() async {
  // Splash and Boarding ViewModels
  serviceLocator.registerFactory<SplashViewModel>(() => SplashViewModel());
  serviceLocator.registerFactory<BoardingViewModel>(() => BoardingViewModel());
}