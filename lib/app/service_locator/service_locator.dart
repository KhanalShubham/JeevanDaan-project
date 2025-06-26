import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:jeevandaan/features/user/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:jeevandaan/features/user/data/data_source/remote_data_source/user_remote_datasource.dart';
import 'package:jeevandaan/features/user/data/repository/remote_repository/user_remote_repository_impl.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_login_use_case.dart';
import 'package:jeevandaan/features/user/domain/use_case/user_register_use_case.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';
// ADDED: Import the new SignupViewModel to register it.
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  // The order of initialization matters.
  // Register dependencies first, then the classes that use them.
  await _initCoreServices();
  await _initUserModule();
  await _initGeneralViewModels();
}

Future<void> _initCoreServices() async {
  // Hive
  serviceLocator.registerLazySingleton(() => HiveServices());

  // Dio & ApiService
  serviceLocator.registerLazySingleton(() => Dio());
  serviceLocator.registerLazySingleton(
    () => ApiService(serviceLocator<Dio>()),
  );

  // Shared Preferences & Token Helper
  // Use 'await' to ensure SharedPreferences is ready before it's used.
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
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
      userLoginUseCase: serviceLocator<UserLoginUseCase>(),
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  // ADDED: The missing registration for SignupViewModel.
  // This is the final step to make the signup flow work correctly.
  serviceLocator.registerFactory(
    () => SignupViewModel(
      userRegisterUseCase: serviceLocator<UserRegisterUseCase>(),
    ),
  );
}

Future _initGeneralViewModels() async {
  // Splash and Boarding ViewModels
  serviceLocator.registerFactory<SplashViewModel>(() => SplashViewModel());
  serviceLocator.registerFactory<BoardingViewModel>(() => BoardingViewModel());
}