// ignore_for_file: prefer_const_constructors

import 'package:chatbox/views/screens/register_screen.dart';
import 'package:flutter/material.dart';

class ExistenLogin extends StatelessWidget {
  const ExistenLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Create an account?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(),
              ),
            );
          },
          child: Text(
            'Register now',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
