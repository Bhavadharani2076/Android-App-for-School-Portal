// import 'package:flutter/material.dart';
// import 'package:schoolportal/Student/Snotificationpage.dart';
//
// class StudentProfilePage extends StatefulWidget {
//   @override
//   _StudentProfilePageState createState() => _StudentProfilePageState();
// }
//
// class _StudentProfilePageState extends State<StudentProfilePage> {
//   // Controllers
//   TextEditingController _searchController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         // Removes shadow
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: CircleAvatar(
//             backgroundImage: AssetImage(
//                 'assets/logo.png'), // Assuming the KRP logo is here
//           ),
//         ),
//         title: Text(
//           'KRP',
//           style: TextStyle(
//             color: Colors.black, // KRP logo and text color
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_none, color: Colors.black),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationPage()),
//               );
//               // Handle notification tap
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: GestureDetector(
//               onTap: () {
//                 // Handle user profile tap
//               },
//               child: CircleAvatar(
//                 backgroundImage: AssetImage(
//                     'assets/user_profile.png'), // User avatar image
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Heading for the page
//             Text(
//               'Student Profiles',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 20), // Space after heading
//             // Search Bar
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 fillColor: Colors.grey[200],
//                 filled: true,
//               ),
//             ),
//             SizedBox(height: 20), // Space after search bar
//             // Student Profiles List (empty currently)
//             Expanded(
//               child: Center(
//                 child: Text(
//                   'No student profiles available.',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
