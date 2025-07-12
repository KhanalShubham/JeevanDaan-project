// features/dashboard/presentation/view/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

import '../view_model/dashboard_event.dart';
import '../view_model/dashboard_state.dart';
import '../view_model/dashboard_view_model.dart';

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
class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: BlocBuilder<DashboardViewModel, DashboardState>(
        builder: (context, state) {
          if (state.isLoading && state.user == null) {
            return _buildLoadingSkeleton(); // Professional loading state
          }
          if (state.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: GoogleFonts.inter(color: AppTheme.secondaryText),
              ),
            );
          }
          // The main, loaded UI
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardViewModel>().add(FetchDashboardData());
            },
            color: AppTheme.primaryRed,
            child: CustomScrollView(
              slivers: [
                _buildHeader(context, state),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildCampaignCarousel(context).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1),
                      _buildQuickActions(context).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1),
                      _buildRequestsSection(context, state).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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

  SliverAppBar _buildHeader(BuildContext context, DashboardState state) {
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
              state.user?.name.isNotEmpty == true ? state.user!.name[0].toUpperCase() : 'U',
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
                state.user?.name.split(' ').first ?? 'User',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Recent Requests', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
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
          // Requests List
          if (state.filteredRequests.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.filteredRequests.length > 5 ? 5 : state.filteredRequests.length,
              itemBuilder: (context, index) {
                return _buildRequestCard(state.filteredRequests[index])
                    .animate()
                    .fadeIn(delay: (100 * index).ms, duration: 500.ms)
                    .slideY(begin: 0.2, curve: Curves.easeOut);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined, size: 60, color: Color(0xFFBDBDBD)),
            const SizedBox(height: 16),
            Text('No requests found.', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
            const SizedBox(height: 4),
            Text(
              'Your active and past requests will appear here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.secondaryText),
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
                  maxLines: 1,
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