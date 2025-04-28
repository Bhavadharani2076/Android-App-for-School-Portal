import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';

class StudentRegister extends StatefulWidget {
  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // Gender selection options
  String selectedGender = 'Select';
  final List<String> genderOptions = ['Select', 'Male', 'Female', 'Other'];

  // Profile image
  File? _image;

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
          'Student Registration',
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
              // Form Header
              Center(
                child: Text(
                  'Student Registration Form',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Profile Picture
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              buildLabelText('Student Name:'),
              buildTextField('Name', nameController),
              const SizedBox(height: 10),

              // Email Field
              buildLabelText('Email:'),
              buildTextField('Email', emailController),
              const SizedBox(height: 10),

              // Contact Number
              buildLabelText('Contact Number:'),
              buildTextField('Contact Number', contactController),
              const SizedBox(height: 10),

              // Class and Section
              Row(
                children: [
                  Expanded(child: buildLabelText('Class:')),
                  const SizedBox(width: 20),
                  Expanded(child: buildLabelText('Section:')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: buildTextField('Class', classController)),
                  const SizedBox(width: 20),
                  Expanded(child: buildTextField('Section', sectionController)),
                ],
              ),
              const SizedBox(height: 10),

              // Date of Birth
              buildLabelText('Date of Birth:'),
              buildTextField('dd/mm/yyyy', dobController),
              const SizedBox(height: 10),

              // Gender Dropdown
              buildLabelText('Gender:'),
              buildDropdown(),
              const SizedBox(height: 10),

              // Blood Group
              buildLabelText('Blood Group:'),
              buildTextField('Blood Group', bloodGroupController),
              const SizedBox(height: 20),

              // Address Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildTextField('Address Line 1', addressLine1Controller),
                    const SizedBox(height: 10),
                    buildTextField('Address Line 2', addressLine2Controller),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: buildTextField('City', cityController)),
                        const SizedBox(width: 10),
                        Expanded(child: buildTextField('State', stateController)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    buildTextField('Country', countryController),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() ) {
                      // Show success message if all fields are filled
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Form Submitted'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Make the background transparent
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 50.0),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
        ],
      ),
    );
  }

  // Helper: Input Label
  Widget buildLabelText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  // Helper: Text Field
  Widget buildTextField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validateField, // Updated to handle nullable
    );
  }

  // Helper: Gender Dropdown
  Widget buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
        color: Colors.grey[200],
      ),
      child: DropdownButton<String>(
        value: selectedGender,
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue!;
          });
        },
        isExpanded: true,
        items: genderOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
