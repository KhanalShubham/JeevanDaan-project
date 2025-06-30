import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_state.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_view_model.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key}); // Changed to const for better performance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainNavigationViewModel, MainNavigationState>(
        builder: (context, state) {
          return state.views.elementAt(state.selectedIndex);
        },
      ),
      bottomNavigationBar: BlocBuilder<MainNavigationViewModel, MainNavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.request_page),
                label: 'Request',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Message',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
            currentIndex: state.selectedIndex,
            // --- Design Enhancements ---
            selectedItemColor: Theme.of(context).primaryColor, // Use your app's primary color
            unselectedItemColor: Colors.grey[600], // A subtle grey for unselected items
            backgroundColor: Theme.of(context).cardColor, // Or Colors.white, for the bar's background
            type: BottomNavigationBarType.fixed, // Ensures all labels are always visible
            elevation: 8.0, // Adds a subtle shadow
            onTap: (index) {
              context.read<MainNavigationViewModel>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}