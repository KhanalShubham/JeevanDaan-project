

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/features/splash/presentation/view/splash_view.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeNotifier(),
      child: Consumer<ThemeModeNotifier>(
        builder: (context, themeNotifier, _) {
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
      ),
    );
  }
}