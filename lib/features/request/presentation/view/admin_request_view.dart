import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jeevandaan/app/themes/themes.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_view_model.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_event.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_state.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRequestView extends StatefulWidget {
  final AdminRequestViewModel viewModel;
  final String token;

  const AdminRequestView({
    Key? key,
    required this.viewModel,
    required this.token,
  }) : super(key: key);

  @override
  State<AdminRequestView> createState() => _AdminRequestViewState();
}

class _AdminRequestViewState extends State<AdminRequestView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterStatus = 'all';
  Timer? _refreshTimer;
  bool _showAnalytics = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _filterStatus = 'all';
              break;
            case 1:
              _filterStatus = 'pending';
              break;
            case 2:
              _filterStatus = 'approved';
              break;
          }
        });
        _refreshRequests();
      }
    });

    // Start real-time refresh timer
    _startRealTimeRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startRealTimeRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _refreshRequests();
      }
    });
  }

  void _refreshRequests() {
    context.read<AdminRequestViewModel>().add(GetAllRequestsForAdminEvent(token: widget.token));
  }

  Future<void> _clearAdminSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_role');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('last_login_timestamp');

    if (context.mounted) {
      // Clear the navigation stack and go to login
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false,
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.accentGreen;
      case 'declined':
        return AppTheme.primaryRed;
      case 'pending':
        return Color(0xFFFF9800); // Orange
      default:
        return AppTheme.secondaryText;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_outline;
      case 'declined':
        return Icons.cancel_outlined;
      case 'pending':
        return Icons.access_time;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: widget.viewModel..add(GetAllRequestsForAdminEvent(token: widget.token)),
      child: BlocBuilder<AdminRequestViewModel, AdminRequestState>(
        builder: (context, state) {
          // Filter requests based on tab selection
          final filteredRequests = _filterStatus == 'all'
              ? state.requests
              : state.requests.where((req) => req.status.toLowerCase() == _filterStatus).toList();

          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppTheme.accentGreen,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              title: Text(
                'Admin Dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _showAnalytics ? Icons.list : Icons.analytics,
                    color: Colors.white,
                  ),
                  tooltip: _showAnalytics ? 'Show Requests' : 'Show Analytics',
                  onPressed: () {
                    setState(() {
                      _showAnalytics = !_showAnalytics;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  tooltip: 'Refresh Requests',
                  onPressed: _refreshRequests,
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Logout',
                  onPressed: () async {
                    // Show confirmation dialog
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Confirm Logout',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: GoogleFonts.poppins(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(color: AppTheme.secondaryText),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryRed,
                            ),
                            child: Text(
                              'Logout',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (shouldLogout == true) {
                      context.read<AdminRequestViewModel>().add(AdminLogoutEvent());
                      await _clearAdminSession(context);
                    }
                  },
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Approved'),
                ],
              ),
            ),
            body: state.isLoading
                ? _buildLoadingState()
                : state.errorMessage != null
                    ? _buildErrorState(context, state.errorMessage!)
                    : _showAnalytics
                        ? _buildAnalyticsDashboard(context, state.requests)
                        : filteredRequests.isEmpty
                            ? _buildEmptyState()
                            : _buildRequestsList(context, filteredRequests),
            floatingActionButton: _showAnalytics ? null : FloatingActionButton(
              backgroundColor: AppTheme.accentGreen,
              child: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _refreshRequests,
              tooltip: 'Refresh Data',
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.accentGreen),
          const SizedBox(height: 16),
          Text(
            'Loading requests...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppTheme.primaryRed),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshRequests,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/empty_state.png', height: 120),
            const SizedBox(height: 16),
            Text(
              'No Requests Found',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _filterStatus == 'all'
                  ? 'There are no requests to review at the moment.'
                  : 'There are no ${_filterStatus} requests to review.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _refreshRequests,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accentGreen,
                side: const BorderSide(color: AppTheme.accentGreen),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalyticsDashboard(BuildContext context, List<RequestEntity> requests) {
    final totalRequests = requests.length;
    final pendingRequests = requests.where((r) => r.status.toLowerCase() == 'pending').length;
    final approvedRequests = requests.where((r) => r.status.toLowerCase() == 'approved').length;
    final declinedRequests = requests.where((r) => r.status.toLowerCase() == 'declined').length;
    
    final totalAmount = requests.fold<double>(0, (sum, r) => sum + r.neededAmount.toDouble());
    final approvedAmount = requests
        .where((r) => r.status.toLowerCase() == 'approved')
        .fold<double>(0, (sum, r) => sum + r.neededAmount.toDouble());
    
    // Calculate today's requests
    final today = DateTime.now();
    final todayRequests = requests.where((r) {
      if (r.createdAt == null) return false;
      final requestDate = r.createdAt!;
      return requestDate.year == today.year &&
             requestDate.month == today.month &&
             requestDate.day == today.day;
    }).length;
    
    // Calculate this week's requests
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekRequests = requests.where((r) {
      if (r.createdAt == null) return false;
      return r.createdAt!.isAfter(weekStart);
    }).length;
    
    return RefreshIndicator(
      onRefresh: () async {
        _refreshRequests();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Real-time indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accentGreen, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Live Analytics • Auto-refresh every 30s',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Overview Cards
            Text(
              'Request Overview',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildAnalyticsCard(
                  'Total Requests',
                  totalRequests.toString(),
                  Icons.inbox,
                  AppTheme.accentGreen,
                ),
                _buildAnalyticsCard(
                  'Pending',
                  pendingRequests.toString(),
                  Icons.access_time,
                  const Color(0xFFFF9800),
                ),
                _buildAnalyticsCard(
                  'Approved',
                  approvedRequests.toString(),
                  Icons.check_circle,
                  AppTheme.accentGreen,
                ),
                _buildAnalyticsCard(
                  'Declined',
                  declinedRequests.toString(),
                  Icons.cancel,
                  AppTheme.primaryRed,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Time-based Analytics
            Text(
              'Time-based Analytics',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsCard(
                    'Today',
                    todayRequests.toString(),
                    Icons.today,
                    AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnalyticsCard(
                    'This Week',
                    weekRequests.toString(),
                    Icons.date_range,
                    AppTheme.accentGreen,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Financial Overview
            Text(
              'Financial Overview',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Requested',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppTheme.secondaryText,
                            ),
                          ),
                          Text(
                            'NPR ${NumberFormat('#,##0').format(totalAmount)}',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.monetization_on,
                          color: AppTheme.accentGreen,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Approved Amount',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppTheme.secondaryText,
                            ),
                          ),
                          Text(
                            'NPR ${NumberFormat('#,##0').format(approvedAmount)}',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${totalAmount > 0 ? ((approvedAmount / totalAmount) * 100).toStringAsFixed(1) : '0'}% Approved',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppTheme.accentGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAnalytics = false;
                        _tabController.animateTo(1); // Go to pending tab
                      });
                    },
                    icon: const Icon(Icons.pending_actions),
                    label: Text(
                      'View Pending ($pendingRequests)',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _refreshRequests,
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      'Refresh Data',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentGreen,
                      side: const BorderSide(color: AppTheme.accentGreen),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRequestsList(BuildContext context, List<RequestEntity> requests) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        final statusColor = _getStatusColor(request.status);
        final statusIcon = _getStatusIcon(request.status);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info and status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: statusColor.withOpacity(0.2),
                      child: Text(
                        request.uploadedBy.isNotEmpty
                            ? request.uploadedBy[0].toUpperCase()
                            : 'U',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.uploadedBy.isNotEmpty
                                ? request.uploadedBy
                                : 'Unknown User',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppTheme.darkText,
                            ),
                          ),
                          Text(
                            'Request ID: ${request.id?.substring(0, 8) ?? 'N/A'}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 16, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            request.status.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Request details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Info rows
                    _buildInfoRow(
                      Icons.monetization_on_outlined,
                      'Amount Requested:',
                      '₹${NumberFormat('#,##0').format(request.neededAmount)}',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.medical_services_outlined,
                      'Medical Condition:',
                      request.condition.toUpperCase(),
                    ),
                    if (request.feedback != null && request.feedback!.isNotEmpty) ...[  
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.comment_outlined,
                        'Admin Feedback:',
                        request.feedback!,
                      ),
                    ],
                    if (request.createdAt != null) ...[  
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.calendar_today_outlined,
                        'Requested On:',
                        DateFormat('MMM dd, yyyy – hh:mm a').format(request.createdAt!),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Action buttons
              if (request.status == 'pending')
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Decline action
                          showDialog(
                            context: context,
                            builder: (_) => UpdateStatusDialog(
                              request: request,
                              token: widget.token,
                              viewModel: context.read<AdminRequestViewModel>(),
                              initialStatus: 'declined',
                            ),
                          );
                        },
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Decline'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryRed,
                          side: const BorderSide(color: AppTheme.primaryRed),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Approve action
                          showDialog(
                            context: context,
                            builder: (_) => UpdateStatusDialog(
                              request: request,
                              token: widget.token,
                              viewModel: context.read<AdminRequestViewModel>(),
                              initialStatus: 'approved',
                            ),
                          );
                        },
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.secondaryText),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppTheme.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UpdateStatusDialog extends StatefulWidget {
  final RequestEntity request;
  final String token;
  final AdminRequestViewModel viewModel;
  final String initialStatus;

  const UpdateStatusDialog({
    Key? key,
    required this.request,
    required this.token,
    required this.viewModel,
    this.initialStatus = 'approved',
  }) : super(key: key);

  @override
  State<UpdateStatusDialog> createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  late String _selectedStatus;
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _amountController.text = widget.request.neededAmount.toString();
    if (widget.request.feedback != null) {
      _feedbackController.text = widget.request.feedback!;
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _selectedStatus == 'approved' 
        ? AppTheme.accentGreen 
        : AppTheme.primaryRed;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  _selectedStatus == 'approved' 
                      ? Icons.check_circle_outline 
                      : Icons.cancel_outlined,
                  color: statusColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedStatus == 'approved' 
                        ? 'Approve Request' 
                        : 'Decline Request',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppTheme.secondaryText,
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Status selection
            Text(
              'Status',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: [
                    DropdownMenuItem(
                      value: 'approved', 
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppTheme.accentGreen, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Approved', 
                            style: GoogleFonts.poppins(color: AppTheme.accentGreen),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'declined', 
                      child: Row(
                        children: [
                          const Icon(Icons.cancel_outlined, color: AppTheme.primaryRed, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Declined', 
                            style: GoogleFonts.poppins(color: AppTheme.primaryRed),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Amount field
            Text(
              'Amount',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                prefixText: '₹ ',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: statusColor),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Feedback field
            Text(
              'Feedback',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: _selectedStatus == 'approved'
                    ? 'Enter any additional notes for the user'
                    : 'Please provide a reason for declining',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: statusColor),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.secondaryText,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateRequestStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Update Status',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _updateRequestStatus() {
    // Validate input
    final amount = int.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    
    if (_selectedStatus == 'declined' && _feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a reason for declining')),
      );
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    // Update request status
    widget.viewModel.add(UpdateRequestStatusEvent(
      requestId: widget.request.id!,
      status: _selectedStatus,
      neededAmount: amount,
      feedback: _feedbackController.text,
      token: widget.token,
    ));
    
    // Close dialog after a short delay to show loading state
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}