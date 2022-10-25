import 'package:flutter/material.dart';

class Course {
  String title;
  String displayName;
  String short;
  Color color;

  Course({
    required this.title,
    required this.displayName,
    required this.short,
    required this.color,
  });

  Widget get circleAvatar {
    return CircleAvatar(
      backgroundColor: color,
      child: Text(
        short,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
