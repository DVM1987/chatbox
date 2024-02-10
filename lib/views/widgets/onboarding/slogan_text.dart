// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SloganText extends StatelessWidget {
  const SloganText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Our chat app is the perfect way to stay connected with friends and family.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
