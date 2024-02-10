// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ButtonLoginSocial extends StatelessWidget {
  const ButtonLoginSocial({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // align to the center horizontally
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white, // border color
              width: 1.0, // border width
            ),
          ),
          child: InkWell(
            onTap: () {
              // handle button press
            },
            child: Image.asset(
              'assets/images/Facebook-f_Logo-Blue-Logo.wine.png',
              width: 40.0, // adjust the width as needed
              height: 40.0, // adjust the height as needed
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white, // border color
              width: 1.0, // border width
            ),
          ),
          child: InkWell(
            onTap: () {
              // handle button press
            },
            child: Image.asset(
              'assets/images/Google_Pay-Logo.wine.png',
              width: 40.0, // adjust the width as needed
              height: 40.0, // adjust the height as needed
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white, // border color
              width: 1.0, // border width
            ),
          ),
          child: InkWell(
            onTap: () {
              // handle button press
            },
            child: Image.asset(
              'assets/images/Vector (3).png',
              width: 40.0, // adjust the width as needed
              height: 40.0, // adjust the height as needed
            ),
          ),
        ),
      ],
    );
  }
}
