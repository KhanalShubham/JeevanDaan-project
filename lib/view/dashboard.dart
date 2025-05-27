import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: Text("Bottom view"),
        
      ),
      bottomNavigationBar: BottomNavigationBar(items: const<BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home", backgroundColor: Colors.green),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Donation", backgroundColor: Colors.yellow),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notification", backgroundColor: Colors.red),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile", backgroundColor: Colors.lightBlue)
      ]),
    );
  }
}
