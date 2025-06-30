import 'package:flutter/material.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/dashboard.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/message.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/notification.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/requestPage.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/Bottom_views/setting.dart';


class MainNavigationState {
  final int selectedIndex;
  final List<Widget> views;

  const MainNavigationState({required this.selectedIndex, required this.views});

  // Initial state
  static MainNavigationState initial() {
    return MainNavigationState(
      selectedIndex: 0,
      views: [
        DashboardPage(),
        RequestPage(),
        MessagePage(),
        NotificationPage(),
        SettingPage()
        
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