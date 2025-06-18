import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Simulated list of notifications
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Alzimer Disease',
      'subtitle': 'Someone is suffering from alzimer',
      'status': 'critical',
      'date': DateTime(2025, 5, 29), // Today (May 29, 2025)
      'isRead': false,
    },
    {
      'title': 'Alzimer Disease',
      'subtitle': 'Someone is suffering from alzimer',
      'status': 'critical',
      'date': DateTime(2025, 5, 29), // Today
      'isRead': false,
    },
    {
      'title': 'Alzimer Disease',
      'subtitle': 'Someone is suffering from alzimer',
      'status': 'critical',
      'date': DateTime(2025, 5, 28), // Yesterday (May 28, 2025)
      'isRead': false,
    },
    {
      'title': 'Alzimer Disease',
      'subtitle': 'Someone is suffering from alzimer',
      'status': 'critical',
      'date': DateTime(2025, 5, 28), // Yesterday
      'isRead': false,
    },
    {
      'title': 'Alzimer Disease',
      'subtitle': 'Someone is suffering from alzimer',
      'status': 'critical',
      'date': DateTime(2025, 5, 28), // Yesterday
      'isRead': false,
    },
  ];

  // Group notifications by date
  Map<String, List<Map<String, dynamic>>> getGroupedNotifications() {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      'Today': [],
      'Yesterday': [],
    };

    final today = DateTime(2025, 5, 29); // Current date (May 29, 2025)
    final yesterday = today.subtract(Duration(days: 1)); // May 28, 2025

    for (var notification in notifications) {
      if (notification['date'].day == today.day &&
          notification['date'].month == today.month &&
          notification['date'].year == today.year) {
        grouped['Today']!.add(notification);
      } else if (notification['date'].day == yesterday.day &&
          notification['date'].month == yesterday.month &&
          notification['date'].year == yesterday.year) {
        grouped['Yesterday']!.add(notification);
      }
    }

    return grouped;
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = getGroupedNotifications();
    final hasNotifications = groupedNotifications['Today']!.isNotEmpty ||
        groupedNotifications['Yesterday']!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: hasNotifications
          ? ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Today Section
                if (groupedNotifications['Today']!.isNotEmpty) ...[
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...groupedNotifications['Today']!.asMap().entries.map((entry) {
                    final index = notifications.indexOf(entry.value);
                    final notification = entry.value;
                    return _buildNotificationCard(notification, index);
                  }).toList(),
                  SizedBox(height: 16),
                ],
                // Yesterday Section
                if (groupedNotifications['Yesterday']!.isNotEmpty) ...[
                  Text(
                    'Yesterday',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...groupedNotifications['Yesterday']!.asMap().entries.map((entry) {
                    final index = notifications.indexOf(entry.value);
                    final notification = entry.value;
                    return _buildNotificationCard(notification, index);
                  }).toList(),
                ],
              ],
            )
          : Center(
              child: Text(
                'No Notifications Yet',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return AnimatedOpacity(
      opacity: notification['isRead'] ? 0.5 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.green[50], // Light green background as in the image
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['subtitle'],
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              SizedBox(height: 4),
              Text(
                notification['status'].toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.ads_click_outlined,
              color: Colors.grey,
            ),
            onPressed: () {
              markAsRead(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Marked as Read')),
              );
            },
          ),
        ),
      ),
    );
  }
}