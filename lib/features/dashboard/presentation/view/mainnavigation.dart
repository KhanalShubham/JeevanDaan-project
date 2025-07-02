// lib/features/dashboard/presentation/view/mainnavigation.dart (Example)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_state.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_view_model.dart';

// ... other imports for your Bottom_views, removed for brevity in this example ...

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainNavigationViewModel, MainNavigationState>(
        builder: (context, state) {
          // This will now correctly show RequestView when selectedIndex is 1
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
                icon: Icon(Icons.request_page), // This is the Request button
                label: 'Request',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
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
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Theme.of(context).cardColor,
            type: BottomNavigationBarType.fixed,
            elevation: 8.0,
            onTap: (index) {
              context.read<MainNavigationViewModel>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}