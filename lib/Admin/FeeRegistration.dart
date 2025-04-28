import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolportal/common.dart';

class FeeRegistration extends StatefulWidget {
  @override
  _FeeRegistrationState createState() => _FeeRegistrationState();
}

class _FeeRegistrationState extends State<FeeRegistration> {
  TextEditingController amountController = TextEditingController();
  TextEditingController lastDateController = TextEditingController();

  List<String> feeTypes = ["Term", "Mid Term", "Transport fee", "Tuition Fees"];
  List<String> feeCategories = ["Tuition Fee", "Cultural Fee", "Exam Fee"];
  List<String> classOptions = List<String>.generate(12, (i) => (i + 1).toString());

  String? selectedFeeType;
  String? selectedFeeCategory;
  String? selectedClass;

  final String apiUrl = ip + "admin_fee_detail.php"; // Update this URL

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        lastDateController.text = formattedDate;
      });
    }
  }

  Future<void> submitFeeData() async {
    if (selectedFeeType == null || selectedFeeCategory == null || amountController.text.isEmpty || selectedClass == null || lastDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final Map<String, String> data = {
      'feetype': selectedFeeType!,
      'fee_cat': selectedFeeCategory!,
      'feeamount': amountController.text,
      'strd': selectedClass!,
      'last_date': lastDateController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: data,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Added Fees Details successfully.'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseBody['message']),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Server error: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to connect to the server. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Fee Upload Form',
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
            _buildLabel('Fees Types'),
            _buildDropdown(feeTypes, selectedFeeType, (String? newValue) {
              setState(() {
                selectedFeeType = newValue;
              });
            }),
            SizedBox(height: 20),
            _buildLabel('Fee Category'),
            _buildDropdown(feeCategories, selectedFeeCategory, (String? newValue) {
              setState(() {
                selectedFeeCategory = newValue;
              });
            }),
            SizedBox(height: 20),
            _buildLabel('Amount'),
            _buildTextField(amountController, 'Enter Amount'),
            SizedBox(height: 20),
            _buildLabel('Class'),
            _buildDropdown(classOptions, selectedClass, (String? newValue) {
              setState(() {
                selectedClass = newValue;
              });
            }),
            SizedBox(height: 20),
            _buildLabel('Last Date'),
            _buildDateField(lastDateController, context),
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
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedItem, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      value: selectedItem,
      hint: Text("Select"),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Select Date",
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.purple),
          onPressed: () {
            _selectDate(context);
          },
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make the background transparent
          foregroundColor: Colors.white, // Text color
          shadowColor: Colors.transparent, // Removes button shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
          ),
        ).copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent), // To set the background to transparent
        ),
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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        onPressed: submitFeeData, // Your onPress method
      ),
    );
  }
}
