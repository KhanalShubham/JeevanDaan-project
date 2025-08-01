// World-Class Stateless Dashboard - JeevanDaan App
// The most beautiful and unique dashboard UI in the world

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
import 'dart:math';
import '../view_model/dashboard_event.dart';
import '../view_model/dashboard_state.dart';
import '../view_model/dashboard_view_model.dart';
import 'package:jeevandaan/core/network/api_service.dart';

// 🎨 World-Class Design System
class DashboardDesign {
  // 🌈 Premium Color Palette
  static const Color primaryRed = Color(0xFFFF4757);
  static const Color primaryBlue = Color(0xFF3742FA);
  static const Color primaryGreen = Color(0xFF2ED573);
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryPurple = Color(0xFF5F27CD);
  static const Color primaryTeal = Color(0xFF00D2D3);
  
  // 🎭 Gradient Magic
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
  );
  
  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
  );
  
  // 📝 Typography
  static const Color darkText = Color(0xFF2C3E50);
  static const Color lightText = Color(0xFF7F8C8D);
  static const Color whiteText = Color(0xFFFFFFFF);
  
  // 🏠 Backgrounds
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF1F3F4);
  
  // ✨ Shadows & Effects
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get heroShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 30,
      offset: const Offset(0, 15),
    ),
  ];
}

// 🚀 Main Dashboard View (Stateless)
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<DashboardViewModel>()..add(FetchDashboardData()),
      child: const _DashboardContent(),
    );
  }
}

// 🎯 Dashboard Content (Stateless)
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardDesign.background,
      body: Consumer<UserNotifier>(
        builder: (context, userNotifier, _) {
          return BlocBuilder<DashboardViewModel, DashboardState>(
            builder: (context, state) {
              final user = userNotifier.user ?? state.user;
              
              if (state.isLoading && user == null) {
                return _buildLoadingSkeleton();
              }
              
              if (state.errorMessage != null) {
                return _buildErrorState(state.errorMessage!);
              }
              
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardViewModel>().add(FetchDashboardData());
                },
                color: DashboardDesign.primaryRed,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildHeroHeader(context, user),
                    _buildAnalyticsSection(context, state),
                    _buildQuickActions(context),
                    _buildRecentRequests(context, state),
                    _buildInsightsSection(context),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 🌟 Hero Header with Gradient
  Widget _buildHeroHeader(BuildContext context, UserEntity? user) {
    return SliverToBoxAdapter(
      child: Container(
        height: 280,
        decoration: const BoxDecoration(
          gradient: DashboardDesign.heroGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroPatternPainter(),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: DashboardDesign.whiteText.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              user?.name ?? 'Welcome',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                color: DashboardDesign.whiteText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Impact Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildImpactCard(
                            icon: Icons.favorite_rounded,
                            title: 'Lives Saved',
                            value: '247',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildImpactCard(
                            icon: Icons.people_rounded,
                            title: 'Donors',
                            value: '1.2K',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
    );
  }

  // 📊 Real-time Analytics Section
  Widget _buildAnalyticsSection(BuildContext context, DashboardState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Analytics',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DashboardDesign.darkText,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildAnalyticsCard(
                  title: 'Active Requests',
                  value: '${state.requests?.length ?? 0}',
                  icon: Icons.bloodtype_rounded,
                  gradient: DashboardDesign.successGradient,
                  trend: '+12%',
                ),
                _buildAnalyticsCard(
                  title: 'This Week',
                  value: '${_getWeeklyCount(state.requests)}',
                  icon: Icons.trending_up_rounded,
                  gradient: DashboardDesign.warningGradient,
                  trend: '+8%',
                ),
                _buildAnalyticsCard(
                  title: 'Urgent Cases',
                  value: '${_getUrgentCount(state.requests)}',
                  icon: Icons.emergency_rounded,
                  gradient: DashboardDesign.dangerGradient,
                  trend: '-3%',
                ),
                _buildAnalyticsCard(
                  title: 'Success Rate',
                  value: '94%',
                  icon: Icons.check_circle_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2ED573), Color(0xFF17C0EB)],
                  ),
                  trend: '+2%',
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
    );
  }

  // ⚡ Quick Actions
  Widget _buildQuickActions(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DashboardDesign.darkText,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildQuickActionCard(
                    icon: Icons.add_circle_rounded,
                    title: 'New Request',
                    subtitle: 'Create blood request',
                    color: DashboardDesign.primaryRed,
                    onTap: () {},
                  ),
                  _buildQuickActionCard(
                    icon: Icons.search_rounded,
                    title: 'Find Donors',
                    subtitle: 'Search nearby',
                    color: DashboardDesign.primaryBlue,
                    onTap: () {},
                  ),
                  _buildQuickActionCard(
                    icon: Icons.chat_bubble_rounded,
                    title: 'Messages',
                    subtitle: 'Chat with donors',
                    color: DashboardDesign.primaryGreen,
                    onTap: () {},
                  ),
                  _buildQuickActionCard(
                    icon: Icons.analytics_rounded,
                    title: 'Reports',
                    subtitle: 'View analytics',
                    color: DashboardDesign.primaryPurple,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
    );
  }

  // 📋 Recent Requests
  Widget _buildRecentRequests(BuildContext context, DashboardState state) {
    final requests = state.requests ?? [];
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Requests',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: DashboardDesign.darkText,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      color: DashboardDesign.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (requests.isEmpty)
              _buildEmptyState()
            else
              ...requests.take(3).map((request) => 
                _buildRequestCard(request).animate().fadeIn(
                  delay: (requests.indexOf(request) * 100).ms,
                  duration: 600.ms,
                ).slideX(begin: 0.2),
              ),
          ],
        ),
      ),
    );
  }

  // 💡 Insights Section
  Widget _buildInsightsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: DashboardDesign.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Daily Insight',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Blood donation saves 3 lives per donation. Your contribution makes a real difference in emergency situations.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 800.ms, duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  // 🎨 Helper Widgets
  Widget _buildImpactCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required LinearGradient gradient,
    required String trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DashboardDesign.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: DashboardDesign.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: DashboardDesign.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DashboardDesign.darkText,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: DashboardDesign.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(RequestEntity request) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (request.status.toLowerCase()) {
      case 'approved':
        statusColor = DashboardDesign.primaryGreen;
        statusText = 'Approved';
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'declined':
        statusColor = DashboardDesign.primaryRed;
        statusText = 'Declined';
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = DashboardDesign.primaryOrange;
        statusText = 'Pending';
        statusIcon = Icons.hourglass_top_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DashboardDesign.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DashboardDesign.cardShadow,
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
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DashboardDesign.darkText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: GoogleFonts.poppins(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 16,
                color: DashboardDesign.lightText,
              ),
              const SizedBox(width: 8),
              Text(
                'Rs. ${NumberFormat('#,##0').format(request.neededAmount)}',
                style: GoogleFonts.poppins(
                  color: DashboardDesign.darkText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (request.createdAt != null)
                Text(
                  DateFormat('MMM dd').format(request.createdAt!),
                  style: GoogleFonts.poppins(
                    color: DashboardDesign.lightText,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: DashboardDesign.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DashboardDesign.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DashboardDesign.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.inbox_rounded,
              size: 48,
              color: DashboardDesign.primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No requests yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: DashboardDesign.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your blood donation requests will appear here',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: DashboardDesign.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Scaffold(
      backgroundColor: DashboardDesign.background,
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: List.generate(4, (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Scaffold(
      backgroundColor: DashboardDesign.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: DashboardDesign.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: DashboardDesign.primaryRed,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Something went wrong',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: DashboardDesign.darkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: DashboardDesign.lightText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔧 Helper Methods
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  int _getWeeklyCount(List<RequestEntity>? requests) {
    if (requests == null) return 0;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return requests.where((r) => 
      r.createdAt != null && r.createdAt!.isAfter(weekStart)
    ).length;
  }

  int _getUrgentCount(List<RequestEntity>? requests) {
    if (requests == null) return 0;
    return requests.where((r) => 
      r.status.toLowerCase() == 'pending' && 
      r.neededAmount > 50000
    ).length;
  }
}

// 🎨 Custom Pattern Painter for Hero Background
class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw geometric pattern
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        final x = (size.width / 10) * i;
        final y = (size.height / 10) * j;
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
