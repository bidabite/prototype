import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({Key? key, this.onTap, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}
