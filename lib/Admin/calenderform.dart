import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolportal/common.dart';

class CalenderForm extends StatefulWidget {
  @override
  _CalendarFormState createState() => _CalendarFormState();
}

class _CalendarFormState extends State<CalenderForm> {
  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Dropdown items
  List<String> leaveTypes = ["Sick Leave", "Casual Leave", "Annual Leave"];
  List<String> everyYearOptions = ["Yes", "No"];
  String? selectedLeaveType;
  String? selectedEveryYear;

  DateTime? startDate;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller, bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        controller.text = formattedDate;

        if (isStart) {
          startDate = pickedDate;
          if (endDateController.text.isNotEmpty) {
            DateTime? endDate = DateFormat('dd-MM-yyyy').parse(endDateController.text);
            if (endDate.isBefore(startDate!)) {
              endDateController.clear();
            }
          }
        }
      });
    }
  }

  void _submitData() async {
    final String url = ip + 'admin_calendar.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'title': nameController.text.trim(),
          'start_date': startDateController.text.trim(),
          'end_date': endDateController.text.trim(),
          'description': descriptionController.text.trim(),
          'type': selectedLeaveType ?? '',
          'every_year': selectedEveryYear == "Yes" ? '1' : '0',
          'badge': 'default_badge', // Provide a default value for the badge
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      // Log the raw response for debugging
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Submitted successfully.')),
          );

          // Clear form fields
          nameController.clear();
          startDateController.clear();
          endDateController.clear();
          descriptionController.clear();
          setState(() {
            selectedLeaveType = null;
            selectedEveryYear = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Submission failed.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar Form',
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
        child: ListView(
          children: [

            SizedBox(height: 20),
            _buildLabel('Title:'),
            _buildTextField(nameController, 'Enter Title'),
            SizedBox(height: 20),
            _buildLabel('Start Date:'),
            _buildDateField(startDateController, context, isStart: true),
            SizedBox(height: 20),
            _buildLabel('End Date:'),
            _buildDateField(endDateController, context, isStart: false),
            SizedBox(height: 20),
            _buildLabel('Description:'),
            _buildTextField(descriptionController, 'Enter Description'),
            SizedBox(height: 20),
            _buildLabel('Leave Type:'),
            _buildDropdown(leaveTypes, selectedLeaveType, (String? newValue) {
              setState(() {
                selectedLeaveType = newValue;
              });
            }),
            SizedBox(height: 20),
            _buildLabel('Every Year:'),
            _buildDropdown(everyYearOptions, selectedEveryYear, (String? newValue) {
              setState(() {
                selectedEveryYear = newValue;
              });
            }),
            SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateField(
      TextEditingController controller, BuildContext context,
      {required bool isStart}) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "dd-mm-yyyy",
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.purple),
          onPressed: () {
            _selectDate(context, controller, isStart);
          },
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(
      List<String> items, String? selectedItem, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(border: OutlineInputBorder()),
      value: selectedItem,
      hint: Text("Choose"),
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Helper method to build submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
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
          borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Make the background transparent
            shadowColor: Colors.transparent, // Optional: removes button shadow
          ),
          onPressed: _submitData,
          child: Text('Submit', style: TextStyle(color: Colors.white,fontSize: 16)),
        ),
      ),
    );
  }

}
