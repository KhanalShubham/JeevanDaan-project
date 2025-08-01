// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:jeevandaan/features/dashboard/presentation/view/mainnavigation.dart';
// import 'package:jeevandaan/features/setting/presentation/view/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SecureHomeWrapper extends StatefulWidget {
//   final String initialRoute;
//   const SecureHomeWrapper({super.key, required this.initialRoute});

//   @override
//   State<SecureHomeWrapper> createState() => _SecureHomeWrapperState();
// }

// class _SecureHomeWrapperState extends State<SecureHomeWrapper> with WidgetsBindingObserver {
//   Timer? _inactivityTimer;
//   Timer? _sessionWarningTimer;
//   bool _locked = false;
//   bool _blurred = false;
//   static const Duration inactivityTimeout = Duration(minutes: 5);
//   static const Duration sessionDuration = Duration(days: 1);
//   static const Duration sessionWarning = Duration(minutes: 10);

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _resetInactivityTimer();
//     _setupSessionWarning();
//   }

//   void _setupSessionWarning() async {
//     final prefs = await SharedPreferences.getInstance();
//     final timestamp = prefs.getInt('last_login_timestamp');
//     if (timestamp != null) {
//       final lastLogin = DateTime.fromMillisecondsSinceEpoch(timestamp);
//       final expiry = lastLogin.add(sessionDuration);
//       final warningTime = expiry.subtract(sessionWarning);
//       final now = DateTime.now();
//       if (now.isBefore(warningTime)) {
//         final delay = warningTime.difference(now);
//         _sessionWarningTimer = Timer(delay, _showSessionExpiryWarning);
//       } else if (now.isBefore(expiry)) {
//         WidgetsBinding.instance.addPostFrameCallback((_) => _showSessionExpiryWarning());
//       }
//     }
//   }

//   void _showSessionExpiryWarning() {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Your session will expire soon. Please re-authenticate to stay logged in.'),
//           backgroundColor: Colors.orange,
//           action: SnackBarAction(
//             label: 'Re-authenticate now',
//             textColor: Colors.white,
//             onPressed: () {
//               _lockApp();
//             },
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _inactivityTimer?.cancel();
//     _sessionWarningTimer?.cancel();
//     super.dispose();
//   }

//   void _resetInactivityTimer() {
//     _inactivityTimer?.cancel();
//     _inactivityTimer = Timer(inactivityTimeout, _lockApp);
//   }

//   void _lockApp() {
//     setState(() {
//       _locked = true;
//     });
//   }

//   void _unlockApp() {
//     setState(() {
//       _locked = false;
//     });
//     _resetInactivityTimer();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
//       setState(() {
//         _blurred = true;
//       });
//     } else if (state == AppLifecycleState.resumed) {
//       setState(() {
//         _blurred = false;
//       });
//       if (_inactivityTimer?.isActive == false) {
//         _lockApp();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: _resetInactivityTimer,
//       onPanDown: (_) => _resetInactivityTimer(),
//       child: Stack(
//         children: [
//           widget.initialRoute == 'dashboard'
//               ? const MainNavigationView()
//               : const Login(),
//           if (_blurred)
//             Positioned.fill(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//                 child: Container(color: Colors.black.withOpacity(0.2)),
//               ),
//             ),
//           if (_locked)
//             Positioned.fill(
//               child: _LockScreen(onUnlock: _unlockApp),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _LockScreen extends StatefulWidget {
//   final VoidCallback onUnlock;
//   const _LockScreen({required this.onUnlock});

//   @override
//   State<_LockScreen> createState() => _LockScreenState();
// }

// class _LockScreenState extends State<_LockScreen> {
//   final _passwordController = TextEditingController();
//   String? _error;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Material(
//       color: Colors.black.withOpacity(0.7),
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.all(32),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
//           ),
//           width: 340,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.lock, size: 48, color: Colors.red),
//               const SizedBox(height: 16),
//               Text('Session Locked', style: theme.textTheme.headlineSmall),
//               const SizedBox(height: 8),
//               Text('Please enter your password to unlock.', style: theme.textTheme.bodyMedium),
//               const SizedBox(height: 24),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   errorText: _error,
//                   border: const OutlineInputBorder(),
//                 ),
//                 onSubmitted: (_) => _tryUnlock(context),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () => _tryUnlock(context),
//                 child: const Text('Unlock'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _tryUnlock(BuildContext context) {
//     if (_passwordController.text.isNotEmpty) {
//       widget.onUnlock();
//     } else {
//       setState(() => _error = 'Password required');
//     }
//   }
// }
