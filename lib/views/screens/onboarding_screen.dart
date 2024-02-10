// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatbox/views/widgets/onboarding/button_login_email.dart';
import 'package:chatbox/views/widgets/onboarding/button_login_social.dart';
import 'package:chatbox/views/widgets/onboarding/existing_login.dart';
import 'package:chatbox/views/widgets/onboarding/intro_text.dart';
import 'package:chatbox/views/widgets/onboarding/logo_text.dart';
import 'package:chatbox/views/widgets/onboarding/or_line.dart';
import 'package:chatbox/views/widgets/onboarding/slogan_text.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 50,
            bottom: 30,
            right: 20,
            left: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LogoText(),
              SizedBox(height: 40),
              IntroText(),
              SloganText(),
              SizedBox(height: 40),
              ButtonLoginSocial(),
              SizedBox(height: 30),
              OrLine(),
              SizedBox(height: 10),
              ButtonSigninEmail(),
              SizedBox(height: 35),
              ExistenLogin(),
            ],
          ),
        ),
      ),
    );
  }
}
