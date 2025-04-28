import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schoolportal/common.dart';

class ExamMarksPage extends StatefulWidget {
  @override
  _ExamMarksPageState createState() => _ExamMarksPageState();
}

class _ExamMarksPageState extends State<ExamMarksPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> students = [];
  Map<String, Map<String, dynamic>> studentMarks = {};

  // Dropdown options
  final List<String> classes = List<String>.generate(12, (index) => (index + 1).toString());
  final List<String> sections = ['A', 'B', 'C', 'D'];
  final List<String> exams = ['Model Exam', 'Final Exam'];
  String? selectedClass;
  String? selectedSection;
  String? selectedExam;

  // Fetch students based on class and section
  Future<void> fetchStudents() async {
    if (selectedClass == null || selectedSection == null) {
      showError('Please select both class and section.');
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(ip + 'staff_user.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'class': selectedClass,
          'section': selectedSection,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            students = List<Map<String, dynamic>>.from(data['data']);
            studentMarks = {
              for (var student in students)
                student['admission_number']: {
                  'name': student['student_name'],
                  'maths': '',
                  'science': '',
                  'english': '',
                  'tamil': '',
                  'social_science': '',
                  'total_grade': ''
                }
            };
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showError(data['message'] ?? 'No students found for this class/section.');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showError('Failed to load students. Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Network error: $e');
    }
  }

  Future<void> submitMarks() async {
    if (selectedExam == null) {
      showError('Please select an exam name.');
      return;
    }

    for (var student in students) {
      final admissionNumber = student['admission_number'];
      final marks = studentMarks[admissionNumber];
      if (marks == null || marks.values.any((value) => value == null || value.toString().trim().isEmpty)) {
        showError('All fields must be filled for each student. Please check the inputs and try again.');
        return;
      }
    }

    try {
      final response = await http.post(
        Uri.parse(ip + 'staff_save_mark.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'class_name': selectedClass,
          'section': selectedSection,
          'exam_name': selectedExam,
          'attendance_date': '2024-11-24',
          'students': students.map((student) {
            return {
              'id': student['admission_number'],
              'marks': studentMarks[student['admission_number']] ?? {},
            };
          }).toList(),
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(data['status'] == 'success' ? 'Success' : 'Error'),
            content: Text(data['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showError('Failed to submit marks. Server error: ${response.statusCode}');
      }
    } catch (e) {
      showError('Network error: $e');
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledButton(String text, VoidCallback? onPressed) {
    return Container(
      width: 200, // Reduced width
      height: 50,
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam Marks',
          style: TextStyle(color: Colors.white),
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
              end: Alignment.centerLeft,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: InputDecoration(labelText: 'Class'),
              items: classes.map((classItem) => DropdownMenuItem(value: classItem, child: Text(classItem))).toList(),
              onChanged: (value) => setState(() => selectedClass = value),
            ),
            DropdownButtonFormField<String>(
              value: selectedSection,
              decoration: InputDecoration(labelText: 'Section'),
              items: sections.map((section) => DropdownMenuItem(value: section, child: Text(section))).toList(),
              onChanged: (value) => setState(() => selectedSection = value),
            ),
            DropdownButtonFormField<String>(
              value: selectedExam,
              decoration: InputDecoration(labelText: 'Exam Name'),
              items: exams.map((exam) => DropdownMenuItem(value: exam, child: Text(exam))).toList(),
              onChanged: (value) => setState(() => selectedExam = value),
            ),
            const SizedBox(height: 24),
            _buildStyledButton('Fetch Students', isLoading ? null : fetchStudents),
            const SizedBox(height: 16),
            if (students.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final admissionNumber = student['admission_number'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${student['student_name']}'),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var subject in ['Maths', 'Science', 'English', 'Tamil', 'Social Science', 'Total Grade'])
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: subject,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            studentMarks[admissionNumber]?[subject.toLowerCase().replaceAll(' ', '_')] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            _buildStyledButton('Submit Marks', isLoading ? null : submitMarks),
          ],
        ),
      ),
    );
  }
}
