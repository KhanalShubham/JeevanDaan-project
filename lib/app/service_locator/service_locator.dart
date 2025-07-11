// lib/core/di/service_locator.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/dashboard/data/data_source/dashboard_remote_data_source.dart';
import 'package:jeevandaan/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:jeevandaan/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_recent_requests_usecase.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_user_details_usecase.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_view_model.dart';
import 'package:jeevandaan/features/request/data/data_source/request_remote_data_source.dart';
import 'package:jeevandaan/features/request/data/repository/request_repository_impl.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'package:jeevandaan/features/request/domain/usecase/add_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/usecase/delete_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/usecase/get_my_requests_usecase.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_view_model.dart'; // Corrected path
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

Future<void> initDependencies() async {
  await _initHiveServices();
  await _initSharedPref();    // Initialize Shared Preferences (including TokenSharedPrefs) FIRST
  await _initApiServices();   // ApiService depends on TokenSharedPrefs, so it comes after
  await _initUserModule();
  await _initRequestModule();
  await _initGeneralViewModels();
  await _initMainNavigationModule();
  await _initDashboardModule();
}

Future<void> _initHiveServices() async{
  serviceLocator.registerLazySingleton(()=>HiveServices());
}

Future<void> _initApiServices() async{
  // FIX: Register Dio as a singleton *before* ApiService
  serviceLocator.registerLazySingleton(() => Dio()); // Register Dio instance first

  serviceLocator.registerLazySingleton(()=>ApiService(
    serviceLocator<Dio>(), // Now Dio can be successfully retrieved
    tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
  ));
  // REMOVE THIS DUPLICATE BLOCK:
  // serviceLocator.registerLazySingleton(() => ApiService(
  //   serviceLocator<Dio>(),
  //   tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(), // Pass TokenSharedPrefs here
  // ));
  // serviceLocator.registerLazySingleton(() => Dio()); // Ensure Dio is registered
}

Future<void> _initSharedPref() async{
  final sharedPref = await SharedPreferences.getInstance();
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
  serviceLocator.registerFactory(
    ()=>UserLocalRepositoryImpl(userLocalDataSource: serviceLocator<UserLocalDataSource>(),)
  );

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
      serviceLocator<UserLoginUseCase>()
    ),
  );

  serviceLocator.registerFactory(
    () => SignupViewModel(
      serviceLocator<UserRegisterUseCase>(),
    ),
  );
}

Future<void> _initGeneralViewModels() async {
  // Splash and Boarding ViewModels
  serviceLocator.registerFactory<SplashViewModel>(() => SplashViewModel());
  serviceLocator.registerFactory<BoardingViewModel>(() => BoardingViewModel());
}

// Request Module Initialization
Future<void> _initRequestModule() async {
  // Data Sources
  serviceLocator.registerLazySingleton<IRequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<IRequestRepository>(
    () => RequestRepositoryImpl(remoteDataSource: serviceLocator<IRequestRemoteDataSource>()),
  );

  // Use Cases
  serviceLocator.registerFactory(() => AddRequestUseCase(serviceLocator<IRequestRepository>()));
  serviceLocator.registerFactory(() => GetMyRequestsUseCase(serviceLocator<IRequestRepository>()));
  serviceLocator.registerFactory(() => DeleteRequestUseCase(serviceLocator<IRequestRepository>()));

  // ViewModel (Bloc)
  serviceLocator.registerFactory(
    () => RequestViewModel(
      addRequestUseCase: serviceLocator<AddRequestUseCase>(),
      getMyRequestsUseCase: serviceLocator<GetMyRequestsUseCase>(),
      deleteRequestUseCase: serviceLocator<DeleteRequestUseCase>(),
    ),
  );
}
Future<void> _initDashboardModule() async {
  // Data Sources
  serviceLocator.registerLazySingleton<IDashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<IDashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: serviceLocator<IDashboardRemoteDataSource>()),
  );

  // Use Cases
  serviceLocator.registerFactory(() => GetUserDetailsUseCase(serviceLocator<IDashboardRepository>()));
  serviceLocator.registerFactory(() => GetRecentRequestsUseCase(serviceLocator<IDashboardRepository>()));

  // ViewModel
  serviceLocator.registerFactory(
    () => DashboardViewModel(
      getUserDetailsUseCase: serviceLocator<GetUserDetailsUseCase>(),
      getRecentRequestsUseCase: serviceLocator<GetRecentRequestsUseCase>(),
    ),
  );
}