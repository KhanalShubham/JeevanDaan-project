import 'package:jeevandaan/app/themes/theme_mode_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/features/splash/presentation/view/splash_view.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:jeevandaan/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:jeevandaan/app/themes/themes.dart';
import 'package:jeevandaan/app/user_notifier.dart';
import 'package:jeevandaan/features/setting/domain/use_case/get_profile_use_case.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
class App extends StatelessWidget {
  const App({super.key});

  Future<void> preloadUserProfile(BuildContext context) async {
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    final tokenSharedPrefs = serviceLocator<TokenSharedPrefs>();
    final getProfileUseCase = serviceLocator<GetProfileUseCase>();
    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold((failure) => token = null, (t) => token = t);
    if (token != null && token!.isNotEmpty) {
      final profileResult = await getProfileUseCase(token!);
      profileResult.fold(
        (failure) {},
        (user) => userNotifier.setUser(user),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModeNotifier()),
        ChangeNotifierProvider(create: (_) => UserNotifier()),
      ],
      child: Builder(
        builder: (context) {
          preloadUserProfile(context); // Preload user info on app start
          return Consumer2<ThemeModeNotifier, UserNotifier>(
            builder: (context, themeNotifier, userNotifier, _) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => serviceLocator<NotificationViewModel>()
                      ..add(GetNotifications()),
                  ),
                ],
                child: MaterialApp(
                  title: 'Jeevan Daan',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeNotifier.themeMode,
                  home: BlocProvider.value(
                    value: serviceLocator<SplashViewModel>(),
                    child: SplashView(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}