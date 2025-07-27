import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:jeevandaan/app/shared_pref/auth_prefs.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/core/network/dio_error_interceptor.dart';
import 'package:jeevandaan/core/network/hive_services.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:jeevandaan/features/chat/data/repository/chat_repository_impl.dart';
import 'package:jeevandaan/features/chat/domain/repository/chat_repository.dart';
import 'package:jeevandaan/features/chat/domain/use_case/get_chat_history_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/listen_for_messages_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/send_chat_file_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/send_text_message_use_case.dart';
import 'package:jeevandaan/features/dashboard/data/data_source/dashboard_remote_data_source.dart';
import 'package:jeevandaan/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:jeevandaan/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_recent_requests_usecase.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_user_details_usecase.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:jeevandaan/features/request/data/data_source/request_remote_data_source.dart';
import 'package:jeevandaan/features/request/data/repository/request_repository_impl.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'package:jeevandaan/features/request/domain/usecase/add_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/usecase/delete_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/usecase/get_my_requests_usecase.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_view_model.dart';
import 'package:jeevandaan/features/setting/data/data_source/settings_remote_data_source.dart';
import 'package:jeevandaan/features/setting/data/repository/settings_repository_impl.dart';
import 'package:jeevandaan/features/setting/domain/repository/settings_repository.dart';
import 'package:jeevandaan/features/setting/domain/use_case/change_password_use_case.dart';
import 'package:jeevandaan/features/setting/domain/use_case/logout_use_case.dart';
import 'package:jeevandaan/features/setting/domain/use_case/update_user_details_use_case.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/change_password_view_model.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/settings_view_model.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/update_profile_view_model.dart';
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
import 'package:jeevandaan/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:jeevandaan/features/notification/data/data_source/notification_remote_data_source.dart';
import 'package:jeevandaan/features/notification/data/repository/notification_repository_impl.dart';
import 'package:jeevandaan/features/notification/domain/repository/notification_repository.dart';
import 'package:jeevandaan/features/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:jeevandaan/features/notification/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:jeevandaan/features/notification/domain/usecase/mark_all_notifications_as_read_usecase.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/setting_view_model.dart';
import 'package:jeevandaan/features/setting/domain/use_case/get_profile_use_case.dart';
import 'package:jeevandaan/features/setting/domain/use_case/update_profile_use_case.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveServices();
  await _initSharedPref();
  await _initApiServices();
  await _initUserModule();
  await _initRequestModule();
  await _initGeneralViewModels();
  await _initDashboardModule();
  await _initChatModule();
  await _initSettingsModule();
  await _initNotificationModule();
}

Future<void> _initHiveServices() async {
  serviceLocator.registerLazySingleton(() => HiveServices());
}

Future<void> _initApiServices() async {
  serviceLocator.registerLazySingleton(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(
        serviceLocator<Dio>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
      ));
}

Future<void> _initSharedPref() async {
  final sharedPref = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPref);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future<void> _initUserModule() async {
  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveservices: serviceLocator<HiveServices>()),
  );
  serviceLocator.registerFactory(
      () => UserLocalRepositoryImpl(userLocalDataSource: serviceLocator<UserLocalDataSource>()));
  serviceLocator.registerFactory<IUserRepository>(
    () => UserRemoteRepositoryImpl(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );
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
  serviceLocator.registerFactory(
    () => UpdateProfileUseCase(serviceLocator<IUserRepository>()),
  );
  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUseCase>()),
  );
  serviceLocator.registerFactory(
    () => SignupViewModel(
      serviceLocator<UserRegisterUseCase>(),
    ),
  );
}

Future<void> _initGeneralViewModels() async {
  serviceLocator.registerFactory<SplashViewModel>(() => SplashViewModel());
  serviceLocator.registerFactory<BoardingViewModel>(() => BoardingViewModel());
}

Future<void> _initRequestModule() async {
  serviceLocator.registerLazySingleton<IRequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerLazySingleton<IRequestRepository>(
    () => RequestRepositoryImpl(remoteDataSource: serviceLocator<IRequestRemoteDataSource>()),
  );
  serviceLocator.registerFactory(() => AddRequestUseCase(serviceLocator<IRequestRepository>()));
  serviceLocator.registerFactory(() => GetMyRequestsUseCase(serviceLocator<IRequestRepository>()));
  serviceLocator.registerFactory(() => DeleteRequestUseCase(serviceLocator<IRequestRepository>()));
  serviceLocator.registerFactory(
    () => RequestViewModel(
      addRequestUseCase: serviceLocator<AddRequestUseCase>(),
      getMyRequestsUseCase: serviceLocator<GetMyRequestsUseCase>(),
      deleteRequestUseCase: serviceLocator<DeleteRequestUseCase>(),
      getAllRequestsForAdminUseCase: ({String? status, String? date, required String token}) =>
        serviceLocator<IRequestRepository>().getAllRequestsForAdmin(status: status, date: date, token: token),
    ),
  );
}

Future<void> _initDashboardModule() async {
  serviceLocator.registerLazySingleton<IDashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerLazySingleton<IDashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: serviceLocator<IDashboardRemoteDataSource>()),
  );
  serviceLocator.registerFactory(() => GetUserDetailsUseCase(serviceLocator<IDashboardRepository>()));
  serviceLocator
      .registerFactory(() => GetRecentRequestsUseCase(serviceLocator<IDashboardRepository>()));
  serviceLocator.registerFactory(
    () => DashboardViewModel(
      getUserDetailsUseCase: serviceLocator<GetUserDetailsUseCase>(),
      getRecentRequestsUseCase: serviceLocator<GetRecentRequestsUseCase>(),
    ),
  );
}

Future<void> _initChatModule() async {
  serviceLocator.registerLazySingleton<IChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      apiService: serviceLocator<ApiService>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
  serviceLocator.registerLazySingleton<IChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: serviceLocator<IChatRemoteDataSource>()),
  );
  serviceLocator.registerFactory(() => GetChatHistoryUseCase(serviceLocator<IChatRepository>()));
  serviceLocator.registerFactory(() => SendTextMessageUseCase(serviceLocator<IChatRepository>()));
  serviceLocator.registerFactory(() => SendChatFileUseCase(serviceLocator<IChatRepository>()));
  serviceLocator.registerFactory(() => ListenForMessagesUseCase(serviceLocator<IChatRepository>()));
}

Future<void> _initNotificationModule() async {
  serviceLocator.registerLazySingleton<INotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerLazySingleton<INotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: serviceLocator<INotificationRemoteDataSource>()),
  );
  serviceLocator.registerFactory(() => GetNotificationsUseCase(serviceLocator<INotificationRepository>()));
  serviceLocator.registerFactory(() => MarkNotificationAsReadUseCase(serviceLocator<INotificationRepository>()));
  serviceLocator.registerFactory(() => MarkAllNotificationsAsReadUseCase(serviceLocator<INotificationRepository>()));
  serviceLocator.registerFactory(() => NotificationViewModel(
    serviceLocator<GetNotificationsUseCase>(),
    serviceLocator<MarkNotificationAsReadUseCase>(),
    serviceLocator<MarkAllNotificationsAsReadUseCase>(),
  ));
}

Future<void> _initSettingsModule() async {
  serviceLocator.registerLazySingleton<ISettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerLazySingleton<ISettingsRepository>(
    () => SettingsRepositoryImpl(remoteDataSource: serviceLocator<ISettingsRemoteDataSource>()),
  );
  serviceLocator
      .registerFactory(() => UpdateUserDetailsUseCase(serviceLocator<ISettingsRepository>()));
  serviceLocator.registerFactory(() => ChangePasswordUseCase(serviceLocator<ISettingsRepository>()));
  serviceLocator.registerFactory(
      () => LogoutUseCase(tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()));
  serviceLocator.registerFactory(() => GetProfileUseCase(serviceLocator<IUserRepository>()));
  serviceLocator.registerFactory(
    () => SettingsViewModel(
      logoutUseCase: serviceLocator<LogoutUseCase>(),
      getUserDetailsUseCase: serviceLocator<GetUserDetailsUseCase>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpdateProfileViewModel(
      updateUserDetailsUseCase: serviceLocator<UpdateUserDetailsUseCase>(),
      getUserDetailsUseCase: serviceLocator<GetUserDetailsUseCase>(),
    ),
  );
  serviceLocator.registerFactory(
    () => ChangePasswordViewModel(
      changePasswordUseCase: serviceLocator<ChangePasswordUseCase>(),
    ),
  );
  serviceLocator.registerFactory(
    () => SettingViewModel(
      getProfileUseCase: serviceLocator<GetProfileUseCase>(),
      updateProfileUseCase: serviceLocator<UpdateProfileUseCase>(),
      changePasswordUseCase: serviceLocator<ChangePasswordUseCase>(),
    ),
  );
}