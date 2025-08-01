import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/request/presentation/view/request_view.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart' as di;
import 'package:jeevandaan/app/themes/themes.dart';
import 'package:jeevandaan/features/chat/presentation/view/chat_view.dart';
import 'package:jeevandaan/features/setting/presentation/view/setting.dart';
import 'package:jeevandaan/features/notification/presentation/views/notification_screen.dart';
import 'package:jeevandaan/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/setting_view_model.dart';
import 'package:jeevandaan/app/user_notifier.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/dashboard_view.dart' hide AppTheme;

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  static final ValueNotifier<int> tabNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tabNotifier,
      builder: (context, selectedIndex, _) {
        return _MainNavigationContent(
          selectedIndex: selectedIndex,
          onTabChanged: (index) => tabNotifier.value = index,
        );
      },
    );
  }
}

class _MainNavigationContent extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _MainNavigationContent({
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  State<_MainNavigationContent> createState() => _MainNavigationContentState();
}

class _MainNavigationContentState extends State<_MainNavigationContent> {
  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;
  int _shakeCount = 0;
  DateTime? _lastShakeTime;
  bool _gyroTriggered = false;



  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEvents.listen(_onAccelerometer);
    _gyroSub = gyroscopeEvents.listen(_onGyroscope);
  }

  @override
  void dispose() {
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
      final currentTab = widget.selectedIndex;
      final nextTab = (currentTab + 1) % 5; // 5 tabs
      widget.onTabChanged(nextTab);
      final tabNames = ['Dashboard', 'Request', 'Message', 'Notifications', 'Setting'];
      final tabName = tabNames[nextTab];
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Switched to "$tabName" tab!',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: AppTheme.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirm Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      debugPrint('[SENSOR] Logging out user');
      await _performLogout('Logged out by shake!');
    }
  }

  Future<void> _performLogout(String message) async {
    try {
      // Clear user state
      Provider.of<UserNotifier>(context, listen: false).clearUser();
      
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      await prefs.remove('user_role');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('last_login_timestamp');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: AppTheme.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        
        // Navigate to login and clear navigation stack
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logout failed. Please try again.',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: AppTheme.primaryRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }



  // Get the pages for navigation
  List<Widget> get _widgetOptions => [
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  Icons.dashboard_rounded,
                  'Dashboard',
                  0,
                  widget.selectedIndex,
                  widget.onTabChanged,
                ),
                _buildNavItem(
                  context,
                  Icons.volunteer_activism_rounded,
                  'Request',
                  1,
                  widget.selectedIndex,
                  widget.onTabChanged,
                ),
                _buildNavItem(
                  context,
                  Icons.message_rounded,
                  'Message',
                  2,
                  widget.selectedIndex,
                  widget.onTabChanged,
                ),
                _buildNavItem(
                  context,
                  Icons.notifications_rounded,
                  'Notifications',
                  3,
                  widget.selectedIndex,
                  widget.onTabChanged,
                ),
                _buildNavItem(
                  context,
                  Icons.settings_rounded,
                  'Setting',
                  4,
                  widget.selectedIndex,
                  widget.onTabChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    int selectedIndex,
    ValueChanged<int> onTap,
  ) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.accentGreen.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                      ? AppTheme.accentGreen
                      : AppTheme.secondaryText,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: isSelected 
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isSelected 
                        ? AppTheme.accentGreen
                        : AppTheme.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}