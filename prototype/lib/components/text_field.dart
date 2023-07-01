import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({Key? key, required this.controller, required this.hintText, required this.obscureText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0052CC)),
          borderRadius: BorderRadius.circular(35)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0052CC)),
            borderRadius: BorderRadius.circular(35)
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF0052CC))
      ),
    );
  }
}
