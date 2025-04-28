// import 'package:flutter/material.dart';
//
// class StdAttendance extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Student Attendance")),
//       body: Center(child: Text("Student Attendance Page")),
//     );
//   }
// }
//
// class Attendancemarking extends StatefulWidget {
//   final String subject;
//   final String className;
//   final String section;
//
//   Attendancemarking({required this.subject, required this.className, required this.section});
//
//   @override
//   _Attendance1State createState() => _Attendance1State();
// }
//
// class _Attendance1State extends State<Attendancemarking> {
//   final TextEditingController searchController = TextEditingController();
//   List<String> allStudents = [
//     'John Doe',
//     'Jane Smith',
//     'Alice Johnson',
//     'Bob Brown',
//     'Charlie Davis',
//     'Daisy Miller',
//     'Eve Thomas',
//     'Frank Wilson',
//     'Grace Lee',
//     'Hank Harris'
//   ];
//   List<String> filteredStudents = [];
//   Map<String, bool?> attendanceStatus = {};
//
//   @override
//   void initState() {
//     super.initState();
//     filteredStudents = List.from(allStudents);
//     for (var student in allStudents) {
//       attendanceStatus[student] = null; // null means not selected
//     }
//   }
//
//   void filterStudents(String query) {
//     setState(() {
//       filteredStudents = allStudents
//           .where((student) => student.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // Navigate to StdAttendance when the logo is clicked
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => StdAttendance()),
//                 );
//               },
//               child: Image.asset('assets/logo.png', height: 40), // Adjust height as needed
//             ),
//             SizedBox(width: 10),
//             Text("KRP", style: TextStyle(color: Colors.black)),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications, color: Colors.black),
//             onPressed: () {
//               // Add notification action
//             },
//           ),
//           SizedBox(width: 15),
//           CircleAvatar(
//             backgroundImage: AssetImage('assets/student.png'), // Adjust profile image as needed
//           ),
//           SizedBox(width: 10),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Attendance for ${widget.subject}, ${widget.className} - ${widget.section}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onChanged: filterStudents,
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(child: Text('S.No', style: headerTextStyle())),
//                 Expanded(flex: 2, child: Text('Students Name', style: headerTextStyle())),
//                 Expanded(child: Text('Present', style: headerTextStyle())),
//                 Expanded(child: Text('Absent', style: headerTextStyle())),
//               ],
//             ),
//             Divider(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: filteredStudents.length,
//                 itemBuilder: (context, index) {
//                   final student = filteredStudents[index];
//                   return Row(
//                     children: [
//                       Expanded(child: Text('${index + 1}')),
//                       Expanded(flex: 2, child: Text(student)),
//                       Expanded(
//                         child: Radio<bool>(
//                           value: true,
//                           groupValue: attendanceStatus[student],
//                           onChanged: (value) {
//                             setState(() {
//                               attendanceStatus[student] = value;
//                             });
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         child: Radio<bool>(
//                           value: false,
//                           groupValue: attendanceStatus[student],
//                           onChanged: (value) {
//                             setState(() {
//                               attendanceStatus[student] = value;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle submit action
//                   print(attendanceStatus);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
//                 ),
//                 child: Text(
//                   'Submit',
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   TextStyle headerTextStyle() {
//     return TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//       color: Colors.blueGrey,
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }
