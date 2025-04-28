import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolportal/common.dart';

class StdAttendanceReport extends StatefulWidget {
  @override
  _StdAttendanceReportState createState() => _StdAttendanceReportState();
}

class _StdAttendanceReportState extends State<StdAttendanceReport> {
  TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> attendanceData = [];

  Future<void> fetchAttendanceData(String month, String admissionNumber) async {
    final url = Uri.parse(ip + 'student_fetch_attendance.php');
    try {
      final response = await http.post(
        url,
        body: {
          'month': month,
          'admission_number': admissionNumber,
        },
      );

      print("Response body: ${response.body}");  // Print response for debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey("error")) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["error"])));
        } else {
          setState(() {
            attendanceData = data.entries.map((entry) {
              final date = entry.key;
              final forenoon = entry.value['FN'];
              final afternoon = entry.value['AN'];

              return {
                "date": date,
                "forenoon": forenoon == 'Present' ? true : forenoon == 'Absent' ? false : null,
                "afternoon": afternoon == 'Present' ? true : afternoon == 'Absent' ? false : null,
              };
            }).toList();
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load data")));
      }
    } catch (e) {
      print("Error: ${e.toString()}");  // Print error for debugging
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occurred")));
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('MMMM, yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Attendance Report',
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: Colors.green.shade300,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select Month and Year',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF0FBBBF),
                            Color(0xFF40E495),
                            Color(0xFF30DD8A),
                            Color(0xFF2BB673),
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft, // Matches the `to left` direction
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white, // The icon color is masked by the gradient
                        ),
                      ),

                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text = DateFormat('MMMM, yyyy').format(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    final selectedDate = DateFormat('yyyy-MM').format(DateFormat('MMMM, yyyy').parse(_dateController.text));
                    fetchAttendanceData(selectedDate, user.substring(1)); // Use global user value
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                          Text('Forenoon', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                          Text('Afternoon', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.black),
                    Expanded(
                      child: ListView.builder(
                        itemCount: attendanceData.length,
                        itemBuilder: (context, index) {
                          final attendance = attendanceData[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(attendance["date"]),
                                  Icon(
                                    attendance["forenoon"] == null
                                        ? Icons.remove_circle_outline
                                        : attendance["forenoon"]! ? Icons.check_circle : Icons.cancel,
                                    color: attendance["forenoon"] == null
                                        ? Colors.grey
                                        : attendance["forenoon"]! ? Colors.green : Colors.red,
                                  ),
                                  Icon(
                                    attendance["afternoon"] == null
                                        ? Icons.remove_circle_outline
                                        : attendance["afternoon"]! ? Icons.check_circle : Icons.cancel,
                                    color: attendance["afternoon"] == null
                                        ? Colors.grey
                                        : attendance["afternoon"]! ? Colors.green : Colors.red,
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
