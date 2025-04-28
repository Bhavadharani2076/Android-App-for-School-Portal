import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Dummy notification data
  final List<Map<String, String>> notificationList = [
    {
      "title": "Tomorrow’s Assignment",
      "icon": "assignment", // icon for demonstration
    },
    {
      "title": "Tomorrow’s Tests",
      "icon": "test", // icon for demonstration
    },
    {
      "title": "Absentees List",
      "icon": "absentees", // icon for demonstration
    },
    {
      "title": "Curriculum",
      "icon": "curriculum", // icon for demonstration
    },
    {
      "title": "Notification 1",
      "icon": "notification", // icon for demonstration
    },
    {
      "title": "Notification 2",
      "icon": "notification", // icon for demonstration
    },
    {
      "title": "Notification 3",
      "icon": "notification", // icon for demonstration
    },
    {
      "title": "Notification 4",
      "icon": "notification", // icon for demonstration
    },
    {
      "title": "Notification 5",
      "icon": "notification", // icon for demonstration
    },
  ];

  // Method to handle download action
  void _onDownloadPressed(String title) {
    // Simulate the download
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The document for $title has been downloaded!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification',
          style: TextStyle(
            color: Colors.white, // Title text color set to white
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0FBBBF),
                Color(0xFF40E495),
                Color(0xFF30DD8A),
                Color(0xFF2BB673),
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft, // Matches the `to left` direction
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Icon(Icons.notifications, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    'Notifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  final notification = notificationList[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, color: Colors.white), // simats icon
                        ),
                        title: Text(notification['title']!),

                        tileColor: Colors.green.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


