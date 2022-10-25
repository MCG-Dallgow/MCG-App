import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'course.dart';

enum GradeFormat {
  format15, format6
}

enum GradeType {
  test, exam
}

class Grade {
  String title;
  Course course;
  int grade;
  GradeFormat format;
  DateTime date;
  GradeType type;

  Grade({
    required this.title,
    required this.course,
    required this.grade,
    required this.format,
    required this.date,
    required this.type,
  });


  _showBottomSheet(context, Grade grade) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: Text(
                grade.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.school,
                color: grade.course.color,
              ),
              title: Text(grade.course.displayName),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: Text("${grade.grade}"),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: Text(DateFormat('EEEE, d. MMMM yyyy', 'de').format(grade.date)),
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: Text(grade.type.name),
            ),
          ],
        );
      },
    );
  }

  Widget listTile(BuildContext context) {
    return ListTile(
      onTap: () => _showBottomSheet(context, this),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            course.displayName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            DateFormat('EEEE, d. MMMM yyyy', 'de').format(date),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: course.color,
        child: Text(
          course.short,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      trailing: Text(
        "$grade",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}