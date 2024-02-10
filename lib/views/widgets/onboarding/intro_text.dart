// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class IntroText extends StatelessWidget {
  const IntroText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Connect',
          style: TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontWeight: FontWeight.w400,
            height: 0.8,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'friends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontWeight: FontWeight.w400,
            height: 0.8,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'easily &',
          style: TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontWeight: FontWeight.w700,
            height: 0.8,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'quickly',
          style: TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
