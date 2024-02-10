// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // align to the center vertically
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Group 477.png', // replace 'your_image.png' with the name of your image file
              fit: BoxFit.contain,
              width: 25.0, // specify your desired width
              height: 25.0, // specify your desired height
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Chatbox', // replace 'Your text' with your desired text
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}
