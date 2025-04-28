import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolportal/common.dart'; // Update this import if needed.

class Attendancesheet extends StatefulWidget {
  @override
  _SAttendanceSheetState createState() => _SAttendanceSheetState();
}

class _SAttendanceSheetState extends State<Attendancesheet> {
  final TextEditingController dateController = TextEditingController();
  String? selectedClass;
  String? selectedSection;
  String? selectedSession;

  List<Map<String, dynamic>> students = [];
  bool isStudentFetched = false;

  @override
  void initState() {
    super.initState();
    // Automatically set the date to today's date in yyyy-MM-dd format
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> fetchStudents() async {
    if (selectedClass == null || selectedSection == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select Class and Section first."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final response = await http.post(
      Uri.parse(ip + 'staff_fetch_user.php'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "class": selectedClass,
        "section": selectedSection,
      }),
    );
    print("Fetch Students Response Status Code: ${response.statusCode}");
    print("Fetch Students Response Body: ${response.body}");
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            students = (data['data'] as List).map((student) {
              return {
                'id': student['admission_number'].toString(),
                'name': student['student_name'].toString(),
                'present': true,
              };
            }).toList();
            isStudentFetched = true;
          });
        } else {
          print("No students found for the selected class and section.");
        }
      } catch (e) {
        print("Error decoding JSON: ${e.toString()}");
      }
    } else {
      print("Error fetching students, status code: ${response.statusCode}");
    }
  }

  Future<void> submitAttendance() async {
    if (!isStudentFetched) {
      await fetchStudents();
      return;
    }
    final absentStudents = students.where((student) => !student['present']).toList();
    _showConfirmationDialog(absentStudents);
  }

  void _showConfirmationDialog(List<Map<String, dynamic>> absentStudents) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Attendance Submission"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("The following students are marked absent:"),
              SizedBox(height: 10),
              ...absentStudents.map((student) => Text(student['name'])).toList(),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop();
                _submitAttendanceToServer();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitAttendanceToServer() async {
    final absentStudents = students.where((student) => !student['present']).toList();
    final presentStudents = students.where((student) => student['present']).toList();
    final requestData = {
      "class_name": selectedClass,
      "section": selectedSection,
      "session": selectedSession,
      "attendance_date": dateController.text,
      "admission_numbers": students.map((student) => student['id'].toString()).toList(),
      "student_names": students.map((student) => student['name'].toString()).toList(),
      "present": presentStudents.map((student) => student['id'].toString()).toList(),
      "absent": absentStudents.map((student) => student['id'].toString()).toList(),
    };
    print("${requestData}");
    final response = await http.post(
      Uri.parse(ip + 'staff_save_attendance.php'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestData),
    );
    print("Submit Attendance Response Status Code: ${response.statusCode}");
    print("Submit Attendance Response Body: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Attendance submitted successfully."),
          backgroundColor: Colors.green,
        ));
        setState(() {
          selectedClass = null;
          selectedSection = null;
          selectedSession = null;
          dateController.clear();
          students.clear();
          isStudentFetched = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error submitting attendance: ${data['message']}"),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error submitting attendance. Please try again."),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Attendance',
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
            Text("Attendance",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedClass,
                    decoration: InputDecoration(labelText: "Class"),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: (index + 1).toString(),
                        child: Text((index + 1).toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedClass = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSection,
                    decoration: InputDecoration(labelText: "Section"),
                    items: List.generate(8, (index) {
                      return DropdownMenuItem(
                        value: String.fromCharCode(65 + index),
                        child: Text(String.fromCharCode(65 + index)), // Sections A to H
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedSection = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSession,
                    decoration: InputDecoration(labelText: "Session"),
                    items: [
                      DropdownMenuItem(value: 'FN', child: Text('FN')),
                      DropdownMenuItem(value: 'AN', child: Text('AN')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSession = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: "Date", hintText: "yyyy-mm-dd"),
                    readOnly: true, // Make it read-only since it's auto-filled
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Row(
                    children: [
                      Expanded(flex: 1, child: Text('${student['id']}')),
                      Expanded(flex: 3, child: Text(student['name'])),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Present'),
                            Checkbox(
                              value: student['present'],
                              onChanged: (bool? value) {
                                setState(() {
                                  student['present'] = value ?? true;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Absent'),
                            Checkbox(
                              value: !student['present'],
                              onChanged: (bool? value) {
                                setState(() {
                                  student['present'] = !(value ?? false);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: submitAttendance,
                child: Text(isStudentFetched ? "Submit Attendance" : "Fetch Students"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
