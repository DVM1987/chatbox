// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class OrLine extends StatelessWidget {
  const OrLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.start, // align to the center horizontally
      children: <Widget>[
        Image.asset(
          'assets/images/Line 38.png', // replace 'your_image1.png' with the name of your first image file
          width: 150.0, // adjust the width as needed
          // adjust the height as needed
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          ' OR ', // replace ' OR ' with your desired text
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          width: 10,
        ),
        Image.asset(
          'assets/images/Line 38.png', // replace 'your_image2.png' with the name of your second image file
          width: 150.0, // adjust the width as needed
          // adjust the height as needed
        ),
      ],
    );
  }
}
