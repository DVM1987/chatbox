// ignore_for_file: prefer_const_constructors

import 'package:chatbox/views/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ButtonSigninEmail extends StatelessWidget {
  const ButtonSigninEmail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10), // Thêm padding nếu cần
      width: double.infinity, // Chiếm hết chiều rộng có thể
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Đặt màu nền cho nút
          foregroundColor: Colors
              .white, // Sử dụng foregroundColor thay cho onPrimary cho màu của text và icon
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bo tròn góc
          ),
          padding: EdgeInsets.symmetric(
              vertical:
                  15), // Điều chỉnh padding cho nút, tăng giảm chiều cao của nút
        ),
        child: Text(
          'Sign in with email',
          style: TextStyle(
            fontSize: 16, // Kích thước font của text
          ),
        ),
      ),
    );
  }
}
