import 'package:flutter/material.dart';
import 'package:schoolportal/Parent/Phome.dart';
import '../Admin/Ahome.dart';
import '../loginpage.dart';
import 'Pnotification.dart';

// import 'HomePage.dart'; // Import your HomePage
// import 'LoginPage.dart'; // Import your LoginPage

class Phomework extends StatefulWidget {
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<Phomework> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Define _scaffoldKey
  int currentIndex = 0; // Current index for bottom navigation

  // Dummy data for subjects and homework
  final List<Map<String, String>> homeworkList = [
    {
      "class": "Class 5",
      "section": "A",
      "subject": "Mathematics",
      "createdDate": "2024-10-20",
      "submissionDate": "2024-10-27",
      "imageUrl": "https://simats.com/homework.jpg" // Use your own image URLs
    },
    {
      "class": "Class 6",
      "section": "B",
      "subject": "Science",
      "createdDate": "2024-10-22",
      "submissionDate": "2024-10-29",
      "imageUrl": "https://simats.com/homework.jpg"
    },
    // Add more homework data here
  ];

  // Method to handle download action
  void _onDownloadPressed(String subject) {
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The homework for $subject has been downloaded!')),
      );
    });
  }

  // Method to navigate between pages
  void _onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Phomework()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Phome()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey, // Assign _scaffoldKey to the Scaffold
      appBar: AppBar(
        title: const Text(
            'Homework',
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
      body: ListView.builder(
        itemCount: homeworkList.length,
        itemBuilder: (context, index) {
          final homework = homeworkList[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      homework['imageUrl']!,
                      height: size.height * 0.25,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _onDownloadPressed(homework['subject']!),
                      icon: Icon(Icons.cloud_download, color: Colors.white),
                      label: Text(
                        "Download",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Created Date: ${homework['createdDate']}',
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'Submission Date: ${homework['submissionDate']}',
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Class', homework['class']!),
                        _buildInfoRow('Section', homework['section']!),
                        _buildInfoRow('Subject', homework['subject']!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue, size: size.width * 0.07),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Colors.blue, size: size.width * 0.07),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send, color: Colors.blue, size: size.width * 0.07),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
