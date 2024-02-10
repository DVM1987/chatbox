// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, avoid_print

import 'package:chatbox/providers/user_provider.dart';
import 'package:chatbox/views/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A), // set
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        leading: BackButton(color: Colors.white), // add a back button
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 40, left: 20.0, right: 20.0, bottom: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Sign up with Email',
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
                  'Get chattig with friends and family by\n signing up for our chat app',
                  textAlign: TextAlign.center, // center the text
                  style: TextStyle(
                    color: Color(0xFF797C7B),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(20.0), // add padding to the Container
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(
                            color:
                                Color(0xFF797C7B)), // set the color of the text
                        decoration: InputDecoration(
                          labelText: 'Your name',
                          labelStyle: TextStyle(color: Color(0xFF797C7B)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                            color:
                                Color(0xFF797C7B)), // set the color of the text
                        decoration: InputDecoration(
                          labelText: 'Your email',
                          labelStyle: TextStyle(color: Color(0xFF797C7B)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ), // add some space between the fields
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                            color:
                                Color(0xFF797C7B)), // set the color of the text
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
                        obscureText: true, // hide the password input
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        style: TextStyle(
                            color:
                                Color(0xFF797C7B)), // set the color of the text
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Color(0xFF797C7B)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF797C7B)),
                          ),
                        ),
                        obscureText: true, // hide the password input
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userCredential.user?.uid)
                              .set({
                            'email': _emailController.text,
                            'name': _nameController.text,
                            // Add any other user data you want to store
                          });
                          Provider.of<UserProvider>(context, listen: false)
                              .updateUser(userCredential.user);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'The password provided is too weak.')),
                            );
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'The account already exists for that email.')),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Text(
                      'Create an account',
                      style: TextStyle(
                        color: Color(0xFF797C7B),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF232929), // background color
                      foregroundColor: Colors.white, // text color
                      minimumSize:
                          Size(double.infinity, 50), // button width and height
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // round the corners
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
