import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schoolportal/common.dart';

class StudentProfilePage extends StatefulWidget {
  @override
  State<StudentProfilePage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<StudentProfilePage> {
  Map<String, dynamic>? studentData;
  List<dynamic> feesData = [];
  bool isLoading = false;
  String errorMessage = "";
  final TextEditingController admissionController = TextEditingController();

  Future<void> fetchStudentProfile(String admissionNumber) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      final response = await http.post(
        Uri.parse(ip + "student_profile.php"),
        body: {'admission_number': admissionNumber},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            studentData = data['student'];
            feesData = data['fees'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['error'] ?? 'Unknown error occurred.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to load data. Status: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Profile',
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
            TextField(
              controller: admissionController,
              decoration: InputDecoration(
                labelText: 'Enter Admission Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final admissionNumber = admissionController.text.trim();
                  if (admissionNumber.isNotEmpty) {
                    fetchStudentProfile(admissionNumber);
                  } else {
                    setState(() {
                      errorMessage = "Admission Number cannot be empty.";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Make the background transparent
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shadowColor: Colors.transparent, // Optional: removes button shadow
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0FBBBF), // Gradient color 1
                        Color(0xFF40E495), // Gradient color 2
                        Color(0xFF30DD8A), // Gradient color 3
                        Color(0xFF2BB673), // Gradient color 4
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft, // Matches the `to left` direction
                    ),
                    borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
                  ),
                  child: Center(
                    child: Text(
                      'Fetch Profile',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(child: Text(errorMessage))
            else if (studentData != null || feesData.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (studentData != null) buildStudentProfileCard(),
                        const SizedBox(height: 30),
                        if (feesData.isNotEmpty) ...[
                          financialSection(
                            "Financial Record - Due List",
                            feesData,
                            "not paid",
                            Colors.red,
                          ),
                          const SizedBox(height: 20),
                          financialSection(
                            "Financial Record - Paid List",
                            feesData,
                            "paid",
                            Colors.green,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget buildStudentProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                ip + "student_image/${studentData!['image_name']}",
              ),
              onBackgroundImageError: (_, __) => const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            Text(
              studentData!['student_name'] ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Class: ${studentData!['class']} '${studentData!['section']}'",
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 30, color: Colors.grey),
            buildDetailRow("Admission Number", studentData!['admission_number']),
            buildDetailRow("Date of Birth", studentData!['date_of_birth']),
            buildDetailRow("Phone Number", studentData!['contact_number']),
            buildDetailRow("Blood Group", studentData!['blood_group']),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget financialSection(
      String title, List<dynamic> fees, String status, Color statusColor) {
    final filteredFees = fees.where((fee) => fee['status'] == status).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Fee Type')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Status')),
              ],
              rows: filteredFees.map((fee) {
                return DataRow(cells: [
                  DataCell(Text(fee['feetype'] ?? '')),
                  DataCell(Text(fee['feecategory'] ?? '')),
                  DataCell(Text(fee['feeamount'].toString())),
                  DataCell(
                    Text(
                      fee['status'] == 'paid' ? 'Paid' : 'Not Paid',
                      style: TextStyle(
                        color: fee['status'] == 'paid'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
