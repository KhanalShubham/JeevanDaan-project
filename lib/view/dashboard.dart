import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // To track the selected bottom navigation item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome,",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
            Text(
              "Shubham Khanal",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage("assets/lottie/images/child.png"),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search",
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Emergency Help",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
  height: 150, // Height of the slider
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 3, // Example: 3 cards for the slider
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 250, // Width of the card
            height: 150, // Height of the card
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image that fills the card
                  Image.asset(
                    "assets/lottie/images/card.png",
                    fit: BoxFit.cover, // Ensures the image fills the card
                  ),
                  // Overlay for text and button
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Support Cancer Warriors",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Donate \$20 to help your nearest hospital.",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Donate",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
            SizedBox(height: 20),
            Text(
              "Organizations:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage("assets/lottie/images/nepal_medical.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  "Nepal Medical College",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "A well-known college with action from nearby doctors",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: Text(
                    "View",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage("assets/lottie/images/trauma.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  "Nepal Trauma Center",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Provides trauma care with top-notch facilities",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: Text(
                    "View",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage("assets/lottie/images/cancer.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  "Cancer Hospital",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "A well-equipped hospital for cancer treatment",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: Text(
                    "View",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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