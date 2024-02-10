// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:chatbox/views/screens/home_screen.dart';
import 'package:chatbox/views/screens/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SpashScreen extends StatefulWidget {
  const SpashScreen({
    super.key,
  });

  @override
  State<SpashScreen> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      if (FirebaseAuth.instance.currentUser != null) {
        // User is signed in. Navigate to YourScreen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => YourScreen()),
        );
      } else {
        // No user is signed in. Navigate to OnboardingScreen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF24786D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 70.0, // specify your desired width
                  height: 70.0, // specify your desired height
                  child: Image.asset(
                    'assets/images/Subtract.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Chatbox',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
