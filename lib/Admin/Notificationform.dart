import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationForm extends StatefulWidget {
  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  // Controllers
  TextEditingController notificationTypeController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // File Upload Dummy Data
  List<String> fileUploadOptions = ["Image", "PDF", "Document"];
  String? selectedFileUpload;

  // Function to select date
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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
      });
    }
  }

  // Validation logic
  bool _validateFields() {
    if (notificationTypeController.text.trim().isEmpty) {
      _showErrorSnackbar('Notification Type is required');
      return false;
    }
    if (messageController.text.trim().isEmpty) {
      _showErrorSnackbar('Message is required');
      return false;
    }
    if (dateController.text.trim().isEmpty) {
      _showErrorSnackbar('Date is required');
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showErrorSnackbar('Description is required');
      return false;
    }
    if (selectedFileUpload == null) {
      _showErrorSnackbar('Please select a file upload type');
      return false;
    }
    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Upload Form',
          style: TextStyle(
            color: Colors.white,
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
              end: Alignment.centerLeft,
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
            _buildTitle('Notification Form'),
            SizedBox(height: 20),
            _buildLabel('Notification Type:'),
            _buildTextField(notificationTypeController, 'Enter Title'),
            SizedBox(height: 20),
            _buildLabel('Message:'),
            _buildTextField(messageController, 'Enter message'),
            SizedBox(height: 20),
            _buildLabel('Date:'),
            _buildDateField(dateController, context),
            SizedBox(height: 20),
            _buildLabel('Upload By:'),
            _buildStaticField('Admin'),
            SizedBox(height: 20),
            _buildLabel('Description:'),
            _buildTextField(descriptionController, 'Description of the message'),
            SizedBox(height: 20),
            _buildLabel('File Upload:'),
            _buildDropdown(fileUploadOptions, selectedFileUpload, (String? newValue) {
              setState(() {
                selectedFileUpload = newValue;
              });
            }),
            SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Helper method to build title
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  // Helper method to build labels
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

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

  // Helper method to build static text field
  Widget _buildStaticField(String text) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: text,
        border: OutlineInputBorder(),
      ),
    );
  }

  // Helper method to build date field with calendar icon
  Widget _buildDateField(TextEditingController controller, BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "dd-mm-yyyy",
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.purple),
          onPressed: () {
            _selectDate(context, controller);
          },
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  // Helper method to build dropdowns
  Widget _buildDropdown(
      List<String> items, String? selectedItem, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      value: selectedItem,
      hint: Text("Choose"),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }


  // Helper method to build submit button
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
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Adjust padding if necessary
            shadowColor: Colors.transparent, // Optional: removes button shadow
          ),
          onPressed: () {
            if (_validateFields()) {
              // Display a SnackBar on successful submission
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Uploaded successfully'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
              // Optionally, clear the fields after submission
              notificationTypeController.clear();
              messageController.clear();
              dateController.clear();
              descriptionController.clear();
              setState(() {
                selectedFileUpload = null; // Reset the dropdown
              });
            }
          },
          child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }


}
