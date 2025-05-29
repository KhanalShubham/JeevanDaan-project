import 'package:flutter/material.dart';
import 'package:jeevandaan/view/Bottom_views/donation.dart';
import 'package:jeevandaan/view/dashboard.dart';
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // List of pages corresponding to each tab
  static final List<Widget> _pages = <Widget>[
    Dashboard(),
    DonationPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Donation",
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.lightBlue,
          ),
        ],
      ),
    );
  }
}