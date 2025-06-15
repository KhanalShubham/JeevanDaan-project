import 'package:get_it/get_it.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initSplashModule();
}
Future _initSplashModule() async {
  // Register Splash ViewModel
  serviceLocator.registerFactory<SplashViewModel>(() => SplashViewModel());
  
  // Register other dependencies as needed
  // Example: serviceLocator.registerLazySingleton<SomeService>(() => SomeServiceImpl());
}

