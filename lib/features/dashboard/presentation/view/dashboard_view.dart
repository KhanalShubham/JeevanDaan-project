// features/dashboard/presentation/view/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:jeevandaan/app/user_notifier.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'dart:async';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import '../view_model/dashboard_event.dart';
import '../view_model/dashboard_state.dart';
import '../view_model/dashboard_view_model.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/mainnavigation.dart';
import 'package:jeevandaan/features/setting/presentation/view/setting.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

// Using a custom theme file is great practice, but for this example,
// we define a refined color palette here.
class AppTheme {
  static const Color primaryRed = Color(0xFFE53935);
  static const Color primaryRedLight = Color(0xFFFFEBEE);
  static const Color accentGreen = Color(0xFF26A69A); // A beautiful teal
  static const Color accentGreenLight = Color(0xFFE0F2F1);
  static const Color darkText = Color(0xFF1B1B1B);
  static const Color secondaryText = Color(0xFF616161);
  static const Color background = Color(0xFFF7F9FC);
  static const Color cardColor = Colors.white;
}

// Main View Wrapper
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<DashboardViewModel>()..add(FetchDashboardData()),
      child: const _DashboardPage(),
    );
  }
}

// The UI Masterpiece
class _DashboardPage extends StatefulWidget {
  const _DashboardPage();

  @override
  State<_DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<_DashboardPage> {
  AccelerometerEvent? _accelerometer;
  GyroscopeEvent? _gyroscope;

  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;

  int _shakeCount = 0;
  DateTime? _lastShakeTime;
  bool _gyroTriggered = false;

  final List<String> _quotes = [
    'Believe you can and you’re halfway there.',
    'Every day is a second chance.',
    'Stay positive, work hard, make it happen.',
    'Difficult roads often lead to beautiful destinations.',
    'You are stronger than you think.',
    'Success is not for the lazy.',
    'Dream big and dare to fail.',
    'Push yourself, because no one else is going to do it for you.',
    'Great things never come from comfort zones.',
    'Don’t watch the clock; do what it does. Keep going.',
  ];
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEvents.listen(_onAccelerometer);
    _gyroSub = gyroscopeEvents.listen(_onGyroscope);
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final online = await ConnectivityService().isOnline;
    setState(() {
      _isOffline = !online;
    });
  }

  void _onAccelerometer(AccelerometerEvent event) {
    final sensorSettings = Provider.of<SensorSettingsNotifier>(context, listen: false);
    if (!sensorSettings.shakeLogoutEnabled) return;
    debugPrint('Accelerometer: x= [1m [1m${event.x} [0m, y=${event.y}, z=${event.z}');
    setState(() => _accelerometer = event);
    final now = DateTime.now();
    if ((event.x.abs() > 15 || event.y.abs() > 15 || event.z.abs() > 15)) {
      if (_lastShakeTime == null || now.difference(_lastShakeTime!) > Duration(seconds: 1)) {
        _shakeCount = 1;
      } else {
        _shakeCount++;
      }
      _lastShakeTime = now;
      if (_shakeCount >= 2) {
        _showLogoutConfirmation();
        _shakeCount = 0;
      }
    }
  }

  void _showLogoutConfirmation() async {
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
      _triggerLogout('Logged out by shake!');
    }
  }

  void _onGyroscope(GyroscopeEvent event) {
    final sensorSettings = Provider.of<SensorSettingsNotifier>(context, listen: false);
    if (!sensorSettings.sensorNavigationEnabled) return;
    debugPrint('Gyroscope: x= [1m${event.x} [0m, y=${event.y}, z=${event.z}');
    setState(() => _gyroscope = event);
    if (!_gyroTriggered && (event.x.abs() > 5 || event.y.abs() > 5 || event.z.abs() > 5)) {
      _gyroTriggered = true;
      // Switch to next tab
      final currentTab = MainNavigationView.tabNotifier.value;
      final nextTab = (currentTab + 1) % 5; // 5 tabs
      MainNavigationView.tabNotifier.value = nextTab;
      final tabNames = ['Dashboard', 'Request', 'Message', 'Notifications', 'Setting'];
      final tabName = tabNames[nextTab];
      _showSensorAction('Switched to "$tabName" tab!');
      Future.delayed(Duration(seconds: 2), () => _gyroTriggered = false);
    }
  }

  void _triggerLogout(String message) {
    // Clear user state
    Provider.of<UserNotifier>(context, listen: false).clearUser();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  void _showSensorAction(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          if (_isOffline)
            Container(
              width: double.infinity,
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: const Text(
                'You are offline. Connect to WiFi or internet to get real-time dashboard.',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: _isOffline
                ? _buildOfflineDashboard()
                : Consumer<UserNotifier>(
                    builder: (context, userNotifier, _) {
                      return BlocBuilder<DashboardViewModel, DashboardState>(
                        builder: (context, state) {
                          final user = userNotifier.user ?? state.user;
                          if (state.isLoading && user == null) {
                            return _buildLoadingSkeleton();
                          }
                          if (state.errorMessage != null) {
                            return Center(
                              child: Text(
                                'Error:  {state.errorMessage}',
                                style: GoogleFonts.inter(color: AppTheme.secondaryText),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () async {
                              await _checkConnectivity();
                              context.read<DashboardViewModel>().add(FetchDashboardData());
                            },
                            color: AppTheme.primaryRed,
                            child: CustomScrollView(
                              slivers: [
                                _buildHeader(context, user),
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      const SizedBox(height: 16),
                                      // Campaign carousel in a card
                                      Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: _buildCampaignCarousel(context)
                                              .animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      // Quick actions in a card
                                      Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                                          child: _buildQuickActions(context)
                                              .animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      // Requests section in a card
                                      Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: _buildRequestsSection(context, state)
                                              .animate().fadeIn(delay: 400.ms, duration: 400.ms),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineDashboard() {
    final quote = _quotes[Random().nextInt(_quotes.length)];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 64, color: Colors.orange.withOpacity(0.7)),
            const SizedBox(height: 24),
            Text(
              'Offline Mode',
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryRed),
            ),
            const SizedBox(height: 16),
            Text(
              quote,
              style: GoogleFonts.inter(fontSize: 18, fontStyle: FontStyle.italic, color: AppTheme.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              'Reconnect to the internet for real-time updates and features.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 16, color: Colors.white),
                  const SizedBox(height: 4),
                  Container(width: 150, height: 20, color: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(height: 150, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(4, (_) => const CircleAvatar(radius: 30))),
          const SizedBox(height: 24),
          Container(width: 200, height: 24, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 50, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
          const SizedBox(height: 16),
          Container(height: 80, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
          const SizedBox(height: 12),
          Container(height: 80, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context, UserEntity? user) {
    return SliverAppBar(
      backgroundColor: AppTheme.background,
      pinned: true,
      elevation: 0,
      stretch: true,
      toolbarHeight: 80,
      title: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryRedLight,
            child: Text(
              user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
              style: GoogleFonts.inter(color: AppTheme.primaryRed, fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: GoogleFonts.inter(color: AppTheme.secondaryText, fontSize: 14),
              ),
              Text(
                user?.name.split(' ').first ?? 'User',
                style: GoogleFonts.inter(color: AppTheme.darkText, fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.secondaryText, size: 28),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // --- MODIFIED WIDGET ---
  Widget _buildCampaignCarousel(BuildContext context) {
    final List<String> campaignImages = [
      'assets/images/card.png', // Create these assets in your project
      'assets/images/card.png',
      'assets/images/card.png',
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: campaignImages.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            shadowColor: Colors.black.withOpacity(0.1),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Ensure you have images in your assets/images folder
                Image.asset(campaignImages[index], fit: BoxFit.cover),
                // Add a gradient overlay for text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    'Hope & Healing Await',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  // --- MODIFIED WIDGET ---
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _quickActionButton(
            context: context,
            icon: Icons.add_circle_outline_rounded,
            label: 'New Request',
            onTap: () {
                // Navigate to the request form
                context.read<DashboardViewModel>().add(NavigateToNewRequest(context: context));
            },
          ),
          _quickActionButton(
            context: context,
            icon: Icons.person_outline_rounded,
            label: 'My Profile',
            onTap: () {
              // Note: A more robust solution uses a shared Cubit/Bloc for the BottomNavBar index.
              // For now, this is a simple placeholder navigation.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Profile Page')),
              );
            },
          ),
          _quickActionButton(
            context: context,
            icon: Icons.local_hospital_outlined,
            label: 'Find Donors',
            onTap: () {},
          ),
          _quickActionButton(
            context: context,
            icon: Icons.share_outlined,
            label: 'Share App',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // --- MODIFIED WIDGET ---
  Widget _quickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppTheme.accentGreen, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.inter(color: AppTheme.secondaryText, fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }

  // --- Unchanged Widgets Below ---

  Widget _buildRequestsSection(BuildContext context, DashboardState state) {
    final requests = state.filteredRequests;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Recent Requests', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
              if (requests.length > 3)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all requests page
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('See All Requests coming soon!')));
                  },
                  child: const Text('See All'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Field
          TextField(
            onChanged: (query) => context.read<DashboardViewModel>().add(SearchRequests(query)),
            decoration: InputDecoration(
              hintText: 'Search by description or condition...',
              hintStyle: GoogleFonts.inter(color: AppTheme.secondaryText),
              prefixIcon: const Icon(Icons.search, color: AppTheme.secondaryText),
              filled: true,
              fillColor: AppTheme.cardColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          if (requests.isEmpty)
            _buildEmptyState(theme)
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length > 3 ? 3 : requests.length,
              itemBuilder: (context, index) {
                return _buildRequestCard(requests[index], theme)
                    .animate()
                    .fadeIn(delay: (100 * index).ms, duration: 500.ms)
                    .slideY(begin: 0.2, curve: Curves.easeOut);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            // Use a friendly illustration (replace with your asset if available)
            Icon(Icons.inbox_outlined, size: 80, color: theme.colorScheme.primary.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text('No requests found.', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
            const SizedBox(height: 4),
            Text(
              'Your active and past requests will appear here. Tap the + button to add a new request!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.secondaryText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(RequestEntity request, ThemeData theme) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (request.status.toLowerCase()) {
      case 'approved':
        statusColor = AppTheme.accentGreen;
        statusText = 'Approved';
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'declined':
        statusColor = AppTheme.primaryRed;
        statusText = 'Declined';
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending';
        statusIcon = Icons.hourglass_top_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  request.description,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: AppTheme.darkText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: GoogleFonts.inter(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),
          Row(
            children: [
              _infoChip(
                Icons.account_balance_wallet_rounded,
                'Needed: Rs. ${NumberFormat('#,##0').format(request.neededAmount)}',
                const Color(0xFF6A1B9A),
              ),
              const SizedBox(width: 12),
              if (request.createdAt != null)
                _infoChip(
                  Icons.calendar_today_rounded,
                  DateFormat('MMM dd, yyyy').format(request.createdAt!),
                  AppTheme.secondaryText,
                ),
            ],
          ),
          if (request.userImage.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                request.userImage,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image, size: 40)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _infoChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(color: AppTheme.secondaryText, fontWeight: FontWeight.w500, fontSize: 13),
        ),
      ],
    );
  }
}