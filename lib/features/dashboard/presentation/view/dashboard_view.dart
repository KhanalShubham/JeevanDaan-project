// features/dashboard/presentation/view/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/request/presentation/view/request_view.dart' as theme;
import '../view_model/dashboard_event.dart';
import '../view_model/dashboard_state.dart';
import '../view_model/dashboard_view_model.dart';
import 'package:intl/intl.dart';

final serviceLocator = GetIt.instance;

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<DashboardViewModel>()..add(FetchDashboardData()),
      child: const _DashboardPage(),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.AppColors.backgroundLight,
      body: BlocBuilder<DashboardViewModel, DashboardState>(
        builder: (context, state) {
          if (state.isLoading && state.user == null) {
            return const Center(child: CircularProgressIndicator(color: theme.AppColors.primaryRed));
          }
          if (state.errorMessage != null) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardViewModel>().add(FetchDashboardData());
            },
            color: theme.AppColors.primaryRed,
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, state),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildPromotionCarousel(),
                      _buildRequestsSection(context, state),
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

  SliverAppBar _buildSliverAppBar(BuildContext context, DashboardState state) {
    return SliverAppBar(
      backgroundColor: theme.AppColors.backgroundLight,
      expandedHeight: 120.0,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Text(
          'Welcome, ${state.user?.name.split(' ').first ?? 'User'}',
          style: theme.AppStyles.heading2.copyWith(color: theme.AppColors.darkText, fontSize: 20),
        ),
        background: Container(color: theme.AppColors.backgroundLight),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundColor: theme.AppColors.primaryRedLight,
            child: Text(
              state.user?.name.isNotEmpty == true ? state.user!.name[0].toUpperCase() : 'U',
              style: const TextStyle(color: theme.AppColors.primaryRed, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCarousel() {
    final List<String> promotionImages = [
      'assets/images/card.png', // Add your image assets
      'assets/images/card.png',
      'assets/images/card.png',
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: promotionImages.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(promotionImages[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _buildRequestsSection(BuildContext context, DashboardState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Requests', style: theme.AppStyles.heading2),
          const SizedBox(height: 16),
          TextField(
            onChanged: (query) {
              context.read<DashboardViewModel>().add(SearchRequests(query));
            },
            decoration: theme.AppDecorations.inputDecoration(
              labelText: 'Search your requests...',
              prefixIcon: const Icon(Icons.search, color: theme.AppColors.greyText),
            ),
          ),
          const SizedBox(height: 16),
          state.filteredRequests.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.filteredRequests.length > 5 ? 5 : state.filteredRequests.length,
                  itemBuilder: (context, index) {
                    return _buildRequestCard(state.filteredRequests[index]);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: theme.AppColors.lightGrey),
            SizedBox(height: 10),
            Text('No requests found', style: theme.AppStyles.subheading),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(RequestEntity request) {
    Color statusColor;
    switch (request.status) {
      case 'approved':
        statusColor = theme.AppColors.successGreen;
        break;
      case 'declined':
        statusColor = theme.AppColors.dangerRed;
        break;
      default:
        statusColor = theme.AppColors.warningOrange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.healing, color: statusColor, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.description,
                    style: theme.AppStyles.cardTitle.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Needed: Rs. ${NumberFormat('#,##0').format(request.neededAmount)}',
                    style: theme.AppStyles.cardSubtitle,
                  ),
                  const SizedBox(height: 4),
                   if (request.createdAt != null)
                    Text(
                      DateFormat('MMM dd, yyyy').format(request.createdAt!),
                      style: theme.AppStyles.cardSubtitle.copyWith(fontSize: 12),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                request.status.toUpperCase(),
                style: theme.AppStyles.statusText.copyWith(color: statusColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}