import 'package:flutter/material.dart';

class Pmarksheet extends StatefulWidget {
  @override
  _ExamMarksPageState createState() => _ExamMarksPageState();
}

class _ExamMarksPageState extends State<Pmarksheet> {
  // List of exams
  final List<String> exams = ['Mid-Term', 'Final', 'Quiz'];
  String selectedExam = 'Mid-Term'; // Default selected exam

  // Subjects and marks for each exam (dummy data)
  final Map<String, List<Map<String, dynamic>>> examSubjects = {
    'Mid-Term': [
      {'subject': 'Mathematics', 'marks': 85},
      {'subject': 'Science', 'marks': 90},
      {'subject': 'English', 'marks': 78},
    ],
    'Final': [
      {'subject': 'Mathematics', 'marks': 88},
      {'subject': 'Science', 'marks': 92},
      {'subject': 'English', 'marks': 80},
    ],
    'Quiz': [
      {'subject': 'Mathematics', 'marks': 75},
      {'subject': 'Science', 'marks': 82},
      {'subject': 'English', 'marks': 70},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Marksheet',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EXAM MARKS:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 20),
            // Enhanced Dropdown with full width, rounded border and shadow
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedExam,
                  icon: Icon(Icons.arrow_drop_down),
                  items: exams.map((String exam) {
                    return DropdownMenuItem<String>(
                      value: exam,
                      child: Text(
                        exam,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedExam = newValue!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            // Table header
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.blueGrey[50],
                    child: Text('Subject', style: headerTextStyle()),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.blueGrey[50],
                    child: Text('Marks', style: headerTextStyle()),
                  ),
                ),
              ],
            ),
            Divider(thickness: 2),
            // List of subjects and marks in table-like format
            Expanded(
              child: ListView.builder(
                itemCount: examSubjects[selectedExam]?.length ?? 0,
                itemBuilder: (context, index) {
                  final subject = examSubjects[selectedExam]![index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              subject['subject'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              subject['marks'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
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

  // Helper method for header text style
  TextStyle headerTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
  }
}
