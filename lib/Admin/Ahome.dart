//Ahome.dart

import 'package:flutter/material.dart';

import 'package:schoolportal/Student/Seventspage.dart';
import 'package:schoolportal/Admin/studentprofile.dart';
import 'package:schoolportal/Student/Snotificationpage.dart';
import 'package:schoolportal/Student/Sprofile.dart';
import 'package:table_calendar/table_calendar.dart';

import '../loginpage.dart';
import 'FacultyRegister.dart';
import 'FeeRegistration.dart';
import 'Notificationform.dart';
import 'StudentRegistration.dart';
import 'calenderform.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// Common Layout for pages with BottomNavigationBar and AppBar
class CommonLayout extends StatelessWidget {
  final Widget bodyContent;
  final int currentIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Define ScaffoldKey

  CommonLayout({required this.bodyContent, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,  // Assign ScaffoldKey here
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent to show gradient
        elevation: 0,
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
              end: Alignment.centerLeft,
            ),
          ),
        ),

        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: size.height * 0.08,
            ),
            SizedBox(width: size.width * 0.04),
            const Text(
              "KRP",
              style: TextStyle(color: Colors.white), // Text color updated for contrast
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white), // Icon color adjusted
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),

      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0FBBBF),
                    Color(0xFF40E495),
                    Color(0xFF30DD8A),
                    Color(0xFF2BB673),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
              child: Text(
                'Welcome, User!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),



            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications '),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationForm()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Calnderform'),
              onTap: () {
                // Navigate to Homework Page (to be implemented)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalenderForm()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('StdRegisterForm'),
              onTap: () {
                // Navigate to Homework Page (to be implemented)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentRegister()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.how_to_reg),
              title: Text('StaffRegisterationForm'),
              onTap: () {
                // Navigate to Events Page (to be implemented)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacultyRegister()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('FeeRegistration Form'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeeRegistration()),
                );
              },
              // Navigate to Financial Report Page (to be implemented)
              // Navigate to Financial Report Page (to be implemented)

            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Navigate to Profile Page (to be implemented)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: bodyContent,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentProfilePage()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeeRegistration()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
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
}

class adminattendance extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<adminattendance> {
  DateTime _selectedDate = DateTime.now();

  // Map of events with DateTime keys and a list of strings (event descriptions)
  final Map<DateTime, List<String>> _events = {
    DateTime(2024, 10, 7): ['Event 1', 'Event 2'],
    DateTime(2024, 10, 14): ['Event 3'],
    DateTime(2021, 6, 21): ['Event 4', 'Event 5', 'Event 6'],
  };

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      currentIndex: 0,
      bodyContent: Column(
        children: [
          // Calendar Widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDate,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
                _showEventsForSelectedDate(selectedDay);
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 20.0, color: Colors.black),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: _buildEventMarker(),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
          // List of All Events
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: _events.entries.expand((entry) {
                  final date = entry.key;
                  final events = entry.value;
                  return events.map((event) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightGreenAccent.withOpacity(0.3),
                              Colors.greenAccent.withOpacity(0.7),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 25,
                          ),
                          title: Text(
                            event,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "${date.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList();
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show events for the selected date
  void _showEventsForSelectedDate(DateTime selectedDate) {
    final events = _events[selectedDate] ?? [];

    if (events.isEmpty) {
      // No events for the selected date
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("No Events"),
            content: Text("There are no events for this date."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    } else {
      // Show events for the selected date
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Events on ${selectedDate.toLocal().toString().split(' ')[0]}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: events.map((event) {
                return ListTile(
                  title: Text(event),
                  leading: Icon(Icons.event),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    }
  }

  // Method to build event marker
  Widget _buildEventMarker() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
      ),
    );
  }
}
// Attendance Page with CommonLayout
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double paddingValue = size.width * 0.04;

    // simats subject list (with attendance and timing)
    final List<Map<String, dynamic>> subjects = [
      {"time": "8:00 AM", "subject": "Biology", "code": "SCB001", "teacher": "Teacher 1", "status": "P"},
      {"time": "8:30 AM", "subject": "Mathematics", "code": "MM001", "teacher": "Teacher 1", "status": "P"},
      {"time": "8:30 AM", "subject": "Language", "code": "LL001", "teacher": "Teacher 1", "status": "A"},
      {"time": "8:30 AM", "subject": "English", "code": "EG001", "teacher": "Teacher 1", "status": "P"},
      {"time": "8:30 AM", "subject": "History", "code": "SSH001", "teacher": "Teacher 1", "status": "P"},
    ];

    return CommonLayout(
      currentIndex: 1,
      bodyContent: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(paddingValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Info
              Container(
                padding: EdgeInsets.all(paddingValue),
                color: Colors.green[300],
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: size.width * 0.08,
                      backgroundImage: AssetImage('assets/student.png'),
                    ),
                    SizedBox(width: paddingValue),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Name',
                          style: TextStyle(fontSize: size.width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'STD: XI   Section: A',
                          style: TextStyle(fontSize: size.width * 0.04, color: Colors.white70),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(size.width * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Admission No.:\n1234',
                        style: TextStyle(fontSize: size.width * 0.035, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text('ATTENDANCE REPORT', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),
              SizedBox(height: size.height * 0.02),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: size.height * 0.015,
                        horizontal: size.width * 0.04,
                      ),
                      title: Text(subject['subject'], style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
                      subtitle: Text("${subject['code']} - ${subject['teacher']}", style: TextStyle(color: Colors.grey[600], fontSize: size.width * 0.035)),
                      leading: Text(subject['time'], style: TextStyle(color: Colors.black54, fontSize: size.width * 0.035)),
                      trailing: CircleAvatar(
                        radius: size.width * 0.04,
                        backgroundColor: subject['status'] == 'P' ? Colors.green : Colors.red,
                        child: Text(subject['status'], style: TextStyle(color: Colors.white, fontSize: size.width * 0.03)),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}