// lib/features/dashboard/presentation/view_model/main_navigation_state.dart

import 'package:flutter/material.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/dashboard.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/message.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/notification.dart';
// import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/requestPage.dart'; // REMOVE this old placeholder
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/setting.dart';
// NEW: Import your consolidated RequestView
import 'package:jeevandaan/features/request/presentation/view/request_view.dart';


class MainNavigationState {
  final int selectedIndex;
  final List<Widget> views;

  const MainNavigationState({required this.selectedIndex, required this.views});

  // Initial state
  static MainNavigationState initial() {
    return MainNavigationState(
      selectedIndex: 0,
      views: [
        const DashboardPage(),
        const RequestView(), // Use your new RequestView here
        const MessagePage(),
        const NotificationPage(),
        const SettingPage()

      ],
    );
  }

  MainNavigationState copyWith({int? selectedIndex, List<Widget>? views}) {
    return MainNavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }
}