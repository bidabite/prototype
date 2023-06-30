import 'package:flutter/cupertino.dart';

class WallPost extends StatelessWidget {
  final String message;
  final String user;
  final String time;
  const WallPost({Key? key, required this.message, required this.user, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(children: [
          Text(user),
          Text(message),
        ],)
      ],
    );
  }
}
