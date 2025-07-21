import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart' as di;
import 'package:jeevandaan/features/chat/presentation/view/chat_view.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:jeevandaan/features/request/presentation/view/request_view.dart';
import 'package:jeevandaan/features/setting/presentation/view/setting.dart';
import 'package:jeevandaan/features/notification/presentation/views/notification_screen.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/setting_view_model.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:jeevandaan/features/setting/presentation/view/setting.dart';
import 'package:jeevandaan/app/user_notifier.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  static final ValueNotifier<int> tabNotifier = ValueNotifier<int>(0);

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0;
  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;
  int _shakeCount = 0;
  DateTime? _lastShakeTime;
  bool _gyroTriggered = false;

  // This list holds the different pages that will be displayed.
  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardView(),
    const RequestView(isAddForm: false),
    const ChatView(),
    BlocProvider(
      create: (_) => di.serviceLocator<NotificationViewModel>()..add(GetNotifications()),
      child: NotificationScreen(),
    ),
    ChangeNotifierProvider(
      create: (_) => di.serviceLocator<SettingViewModel>(),
      child: SettingPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    MainNavigationView.tabNotifier.addListener(_onTabChanged);
    _accelSub = accelerometerEvents.listen(_onAccelerometer);
    _gyroSub = gyroscopeEvents.listen(_onGyroscope);
  }

  @override
  void dispose() {
    MainNavigationView.tabNotifier.removeListener(_onTabChanged);
    _accelSub?.cancel();
    _gyroSub?.cancel();
    super.dispose();
  }

  void _onAccelerometer(AccelerometerEvent event) {
    final sensorSettings = Provider.of<SensorSettingsNotifier>(context, listen: false);
    debugPrint('[SENSOR] Accelerometer event: x=${event.x}, y=${event.y}, z=${event.z}, shakeLogoutEnabled=${sensorSettings.shakeLogoutEnabled}');
    if (!sensorSettings.shakeLogoutEnabled) return;
    final now = DateTime.now();
    if ((event.x.abs() > 15 || event.y.abs() > 15 || event.z.abs() > 15)) {
      if (_lastShakeTime == null || now.difference(_lastShakeTime!) > Duration(seconds: 1)) {
        _shakeCount = 1;
      } else {
        _shakeCount++;
      }
      _lastShakeTime = now;
      debugPrint('[SENSOR] Shake count: $_shakeCount');
      if (_shakeCount >= 2) {
        debugPrint('[SENSOR] Triggering logout confirmation dialog');
        _showLogoutConfirmation();
        _shakeCount = 0;
      }
    }
  }

  void _onGyroscope(GyroscopeEvent event) {
    final sensorSettings = Provider.of<SensorSettingsNotifier>(context, listen: false);
    debugPrint('[SENSOR] Gyroscope event: x=${event.x}, y=${event.y}, z=${event.z}, sensorNavigationEnabled=${sensorSettings.sensorNavigationEnabled}');
    if (!sensorSettings.sensorNavigationEnabled) return;
    if (!_gyroTriggered && (event.x.abs() > 5 || event.y.abs() > 5 || event.z.abs() > 5)) {
      _gyroTriggered = true;
      debugPrint('[SENSOR] Rapid rotation detected, switching tab');
      // Switch to next tab
      final currentTab = MainNavigationView.tabNotifier.value;
      final nextTab = (currentTab + 1) % 5; // 5 tabs
      MainNavigationView.tabNotifier.value = nextTab;
      final tabNames = ['Dashboard', 'Request', 'Message', 'Notifications', 'Setting'];
      final tabName = tabNames[nextTab];
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Switched to "$tabName" tab!')),
        );
      }
      // Debounce: prevent retrigger for 1.5 seconds
      Future.delayed(const Duration(milliseconds: 1500), () => _gyroTriggered = false);
    }
  }

  void _showLogoutConfirmation() async {
    if (!mounted) return;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      debugPrint('[SENSOR] Logging out user');
      Provider.of<UserNotifier>(context, listen: false).clearUser();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out by shake!')),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
      }
    }
  }

  void _onTabChanged() {
    setState(() {
      _selectedIndex = MainNavigationView.tabNotifier.value;
    });
  }

  // This function is called when a tab is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // A helper function to create simple placeholder pages.
  // We still need this for the "Notifications" tab.
  static Widget _buildPlaceholder(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism_rounded),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFE53935), // Primary Red
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8.0,
        showUnselectedLabels: true,
      ),
    );
  }
}