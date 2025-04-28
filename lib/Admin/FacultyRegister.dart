import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';

class FacultyRegister extends StatefulWidget {
  @override
  _FacultyRegisterState createState() => _FacultyRegisterState();
}

class _FacultyRegisterState extends State<FacultyRegister> {
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController dateOfJoiningController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // Status dropdown selection
  String? selectedStatus;

  // Profile image
  File? _image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to pick an image
  Future<void> _pickImage() async {
    final params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.image,
      allowEditing: false,
    );
    final filePath = await FlutterFileDialog.pickFile(params: params);
    if (filePath != null) {
      setState(() {
        _image = File(filePath);
      });
    }
  }

  // Helper function to validate text fields
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Faculty Registration',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  'Faculty Registration Form',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Profile picture avatar (optional)
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Name field
              buildTextField('Faculty Name', nameController),
              // Email field
              buildTextField('Email', emailController),
              // Contact Number field
              buildTextField('Contact Number', contactController),
              // Degree field
              buildTextField('Degree', degreeController),
              // Experience field
              buildTextField('Experience (in years)', experienceController),
              // Date of Birth field
              buildTextField('Date of Birth', dobController, hintText: 'dd/mm/yyyy'),
              // Date of Joining field
              buildTextField('Date of Joining', dateOfJoiningController, hintText: 'dd/mm/yyyy'),

              // Status (Currently Working or Not)
              SizedBox(height: 20),
              Text(
                'Status:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
              ),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ['Currently Working', 'Not Working'].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: validateField,
              ),
              SizedBox(height: 20),

              // Address Section (bordered container)
              Text(
                'Address:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    buildTextField('Address Line 1', addressLine1Controller),
                    buildTextField('Address Line 2', addressLine2Controller),
                    buildTextField('City', cityController),
                    buildTextField('State', stateController),
                    buildTextField('Country', countryController),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Submit button
              // Submit button with gradient background
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Form submitted successfully!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Make the background transparent
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 50.0),
                    shadowColor: Colors.transparent, // Optional: removes button shadow
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
                      borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget buildTextField(String label, TextEditingController controller, {String hintText = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText.isNotEmpty ? hintText : label,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: validateField,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    dobController.dispose();
    degreeController.dispose();
    experienceController.dispose();
    dateOfJoiningController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    super.dispose();
  }
}
