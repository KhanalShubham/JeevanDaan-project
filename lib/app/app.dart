import 'dart:async';
import 'dart:ui';
import 'package:jeevandaan/app/themes/theme_mode_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart' as app_services;
import 'package:jeevandaan/features/splash/presentation/view/splash_view.dart';
import 'package:jeevandaan/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:jeevandaan/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:jeevandaan/app/themes/themes.dart';
import 'package:jeevandaan/app/user_notifier.dart';
import 'package:jeevandaan/features/setting/domain/use_case/get_profile_use_case.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:jeevandaan/features/setting/presentation/view/setting.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/mainnavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  final String initialRoute;
  const App({super.key, required this.initialRoute});

  Future<void> preloadUserProfile(BuildContext context) async {
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    final tokenSharedPrefs = app_services.serviceLocator<TokenSharedPrefs>();
    final getProfileUseCase = app_services.serviceLocator<GetProfileUseCase>();
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

  void showAutoLoginSnackbar(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome back! You have been logged in automatically.'), backgroundColor: Colors.green),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModeNotifier()),
        ChangeNotifierProvider(create: (_) => UserNotifier()),
        ChangeNotifierProvider(create: (_) => SensorSettingsNotifier()),
      ],
      child: Builder(
        builder: (context) {
          preloadUserProfile(context); // Preload user info on app start
          if (initialRoute == 'dashboard') {
            showAutoLoginSnackbar(context);
          }
          return Consumer2<ThemeModeNotifier, UserNotifier>(
            builder: (context, themeNotifier, userNotifier, _) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => app_services.serviceLocator<NotificationViewModel>()
                      ..add(GetNotifications()),
                  ),
                  BlocProvider(
                    create: (context) => app_services.serviceLocator<LoginViewModel>(),
                  ),
                ],
                child: MaterialApp(
                  title: 'Jeevan Daan',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeNotifier.themeMode,
                  home: SecureHomeWrapper(initialRoute: initialRoute),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SecureHomeWrapper extends StatefulWidget {
  final String initialRoute;
  const SecureHomeWrapper({super.key, required this.initialRoute});

  @override
  State<SecureHomeWrapper> createState() => _SecureHomeWrapperState();
}

class _SecureHomeWrapperState extends State<SecureHomeWrapper> with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  Timer? _sessionWarningTimer;
  bool _locked = false;
  bool _blurred = false;
  static const Duration inactivityTimeout = Duration(minutes: 5);
  static const Duration sessionDuration = Duration(days: 1);
  static const Duration sessionWarning = Duration(minutes: 10);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetInactivityTimer();
    _setupSessionWarning();
  }

  void _setupSessionWarning() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('last_login_timestamp');
    if (timestamp != null) {
      final lastLogin = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final expiry = lastLogin.add(sessionDuration);
      final warningTime = expiry.subtract(sessionWarning);
      final now = DateTime.now();
      if (now.isBefore(warningTime)) {
        final delay = warningTime.difference(now);
        _sessionWarningTimer = Timer(delay, _showSessionExpiryWarning);
      } else if (now.isBefore(expiry)) {
        // If already within warning window, show immediately
        WidgetsBinding.instance.addPostFrameCallback((_) => _showSessionExpiryWarning());
      }
    }
  }

  void _showSessionExpiryWarning() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Your session will expire soon. Please re-authenticate to stay logged in.'),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: 'Re-authenticate now',
            textColor: Colors.white,
            onPressed: () {
              _lockApp();
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    _sessionWarningTimer?.cancel();
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(inactivityTimeout, _lockApp);
  }

  void _lockApp() {
    setState(() {
      _locked = true;
    });
  }

  void _unlockApp() {
    setState(() {
      _locked = false;
    });
    _resetInactivityTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      setState(() {
        _blurred = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _blurred = false;
      });
      if (_inactivityTimer?.isActive == false) {
        _lockApp();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: Stack(
        children: [
          widget.initialRoute == 'dashboard'
              ? const MainNavigationView()
              : const Login(),
          if (_blurred)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),
          if (_locked)
            Positioned.fill(
              child: _LockScreen(onUnlock: _unlockApp),
            ),
        ],
      ),
    );
  }
}

class _LockScreen extends StatefulWidget {
  final VoidCallback onUnlock;
  const _LockScreen({required this.onUnlock});

  @override
  State<_LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<_LockScreen> {
  final _passwordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
          ),
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Session Locked', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Please enter your password to unlock.', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _error,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _tryUnlock(context),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _tryUnlock(context),
                child: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tryUnlock(BuildContext context) async {
    // For demo: accept any non-empty password. In production, check against stored hash or re-authenticate.
    if (_passwordController.text.isNotEmpty) {
      widget.onUnlock();
    } else {
      setState(() => _error = 'Password required');
    }
  }
}