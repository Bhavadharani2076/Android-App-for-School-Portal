import 'package:flutter/material.dart';
import 'package:schoolportal/Admin/StudentRegistration.dart';

import 'package:schoolportal/Parent/Phomework.dart';
import 'package:schoolportal/Parent/Pnotification.dart';
import 'package:schoolportal/Parent/Pstdprofile.dart';
import 'package:schoolportal/Staff/SThomewoek.dart';
import 'package:schoolportal/Student/Seventspage.dart';
import 'package:schoolportal/Student/ExamMarksPage.dart';
import 'package:schoolportal/Admin/FacultyRegister.dart';
import 'package:schoolportal/Admin/FeeRegistration.dart';

import 'package:schoolportal/Admin/Notificationform.dart';
import 'package:schoolportal/Staff/attendancemarking.dart';
import 'package:schoolportal/Admin/calenderform.dart';

import 'package:schoolportal/loginpage.dart';
import 'package:schoolportal/Staff/Sattendancesheet.dart';
import 'package:schoolportal/Student/Sprofile.dart';
import 'package:schoolportal/Student/Shome.dart';
import 'package:schoolportal/studentprofile.dart';
import 'dart:async';

import 'Parent/Pmarksheet.dart';
import 'Student/Shomeworkpage.dart';
import 'Student/Snotificationpage.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to FirstPage after 1 second
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'), // Add your image in assets
      ),
    );
  }
}

