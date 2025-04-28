import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schoolportal/common.dart';
import 'package:intl/intl.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({Key? key}) : super(key: key);

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController classController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController lastDateController = TextEditingController();
  //final TextEditingController dummyFileController = TextEditingController(); // Dummy file controller

  bool isLoading = false;

  // Predefined lists for dropdowns
  final List<String> classes = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  final List<String> sections = ['A', 'B', 'C', 'D'];
  final List<String> subjects = [
    'Mathematics',
    'Science',
    'English',
    'Social Studies',
    'Computer Science',
    'Physical Education'
  ];

  // Constant filename to pass to backend
  final String constantFileName = "activity.png";

  @override
  void initState() {
    super.initState();
    // Set current date as default
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    classController.dispose();
    sectionController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    lastDateController.dispose();
    //dummyFileController.dispose(); // Dispose dummy file controller
    super.dispose();
  }

  Future<void> submitHomework() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => isLoading = true);
    try {
      var uri = Uri.parse(ip + 'staff_insert_homework.php');
      var request = http.MultipartRequest('POST', uri);
      // Add form fields
      request.fields['class'] = classController.text;
      request.fields['section'] = sectionController.text;
      request.fields['subject'] = subjectController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['date'] = dateController.text;
      request.fields['last_date'] = lastDateController.text;
      request.fields['constant_file_name'] = constantFileName;
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        showSuccessSnackBar('Homework uploaded successfully');
        clearForm();
      } else {
        showErrorSnackBar('Error: $responseBody');
      }
    } catch (e) {
      showErrorSnackBar('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void clearForm() {
    classController.clear();
    sectionController.clear();
    subjectController.clear();
    descriptionController.clear();
    lastDateController.clear();
    //dummyFileController.clear(); // Clear dummy file field
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Homework',
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
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Class Dropdown
                  DropdownButtonFormField<String>(
                    value: classController.text.isEmpty ? null : classController.text,
                    decoration: const InputDecoration(
                      labelText: 'Class',
                      border: OutlineInputBorder(),
                    ),
                    items: classes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Please select a class' : null,
                    onChanged: (value) => classController.text = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  // Section Dropdown
                  DropdownButtonFormField<String>(
                    value: sectionController.text.isEmpty ? null : sectionController.text,
                    decoration: const InputDecoration(
                      labelText: 'Section',
                      border: OutlineInputBorder(),
                    ),
                    items: sections.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Please select a section' : null,
                    onChanged: (value) => sectionController.text = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  // Subject Dropdown
                  DropdownButtonFormField<String>(
                    value: subjectController.text.isEmpty ? null : subjectController.text,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    items: subjects.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Please select a subject' : null,
                    onChanged: (value) => subjectController.text = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  // Description Field
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter assignment description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
                  ),
                  const SizedBox(height: 16),
                  // Assignment Date
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Assignment Date',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, dateController),
                      ),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please select a date' : null,
                  ),
                  const SizedBox(height: 16),
                  // Last Date
                  TextFormField(
                    controller: lastDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Submission Deadline',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, lastDateController),
                      ),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please select a deadline' : null,
                  ),
                  const SizedBox(height: 24),
                  // Submit Button with gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0FBBBF),
                          Color(0xFF40E495),
                          Color(0xFF30DD8A),
                          Color(0xFF2BB673),
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submitHomework,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shadowColor: Colors.transparent,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Submit Assignment',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
