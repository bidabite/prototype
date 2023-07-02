import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.comment,
      color: Colors.grey,
    );
  }
}
