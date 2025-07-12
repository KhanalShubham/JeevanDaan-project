import 'package:flutter/material.dart';
import 'package:jeevandaan/features/chat/presentation/view/chat_view.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:jeevandaan/features/request/presentation/view/request_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0;

  // This list holds the different pages that will be displayed.
  // We've replaced the placeholders with your actual views.
  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardView(),
    const RequestView(isAddForm: false), // Default to showing the list of requests
    const ChatView(),      // Placeholder for now
    _buildPlaceholder('Notifications'),// Placeholder for now
    _buildPlaceholder('Setting'),      // Placeholder for now
  ];

  // This function is called when a tab is tapped.
  // It updates the state to show the new page.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // A helper function to create simple placeholder pages.
  static Widget _buildPlaceholder(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the widget from our list at the current index.
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism_rounded),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        // Using a vibrant color for the selected item makes it pop.
        selectedItemColor: const Color(0xFFE53935), // Primary Red
        // A muted color for unselected items keeps the UI clean.
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        // 'fixed' ensures all labels are visible and the background color is applied.
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8.0,
        showUnselectedLabels: true,
      ),
    );
  }
}