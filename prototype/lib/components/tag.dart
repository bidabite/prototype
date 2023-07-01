import 'package:flutter/cupertino.dart';

class MyTag extends StatelessWidget {
  final String name;
  final Color color;
  const MyTag({Key? key, required this.name, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(
        name,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12
        ),
      ),
    );
  }
}
