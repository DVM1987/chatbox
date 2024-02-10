// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously, avoid_print

import 'package:chatbox/providers/user_provider.dart';
import 'package:chatbox/views/screens/home_screen.dart';
import 'package:chatbox/views/widgets/onboarding/button_login_social.dart';
import 'package:chatbox/views/widgets/onboarding/or_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  // ignore: super-parameters
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 40, left: 20.0, right: 20.0, bottom: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Log in to Chatbox',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Welcome back! Sign in using your social\n account or email to continue with us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF797C7B),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ButtonLoginSocial(),
              SizedBox(
                height: 30,
              ),
              OrLine(),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Color(0xFF797C7B)),
                        decoration: InputDecoration(
                          labelText: 'Your Email',
                          labelStyle: TextStyle(color: Color(0xFF797C7B)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(color: Color(0xFF797C7B)),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Color(0xFF797C7B)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Column(
                children: <Widget>[
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              Provider.of<UserProvider>(context, listen: false)
                                  .updateUser(userCredential.user);
                              Provider.of<UserProvider>(context, listen: false)
                                  .updateUserActivity(_emailController.text);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        YourScreen()), // Đảm bảo rằng HomeScreen được import và sử dụng đúng cách.
                              );
                            } on FirebaseAuthException catch (e) {
                              String errorMessage;
                              if (e.code == 'user-not-found') {
                                errorMessage = 'No user found for that email.';
                              } else if (e.code == 'wrong-password') {
                                errorMessage =
                                    'Wrong password provided for that user.';
                              } else {
                                errorMessage =
                                    'An error occurred: ${e.message}';
                              }
                              // Sử dụng context từ Builder để hiển thị SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            } catch (e) {
                              // Trường hợp bắt các loại lỗi khác
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('An error occurred: $e')),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: Color(0xFF797C7B),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF232929),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      // handle button press
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF5EBAAE),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
