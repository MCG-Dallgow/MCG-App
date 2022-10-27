import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/screens/grades/grade_edit_screen.dart';
import 'package:mcgapp/screens/grades/grades_screen.dart';
import 'package:mcgapp/widgets/bottom_sheet.dart';

import '../screens/grades/course_grades_screen.dart';
import 'course.dart';

enum GradeFormat { format15, format6 }

enum GradeType { test, exam }

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

  List<Widget> get _details {
    return [
      ListTile(
        leading: Icon(
          Icons.school,
          color: course.color,
        ),
        title: Text(course.displayName),
      ),
      ListTile(
        leading: const Icon(Icons.star),
        title: Text("$grade"),
      ),
      ListTile(
        leading: const Icon(Icons.event),
        title: Text(DateFormat('EEEE, d. MMMM yyyy', 'de').format(date)),
      ),
      ListTile(
        leading: const Icon(Icons.text_fields),
        title: Text(type.name),
      ),
    ];
  }

  List<Widget> _actions(BuildContext context) {
    return <Widget>[
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          foregroundColor: themeManager.colorStroke,
        ),
        child: Row(
          children: const [
            Icon(Icons.edit),
            SizedBox(width: 8),
            Text('Bearbeiten'),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  GradeEditScreen(grade: this, returnToScreen: CourseGradesScreen(course: course)),
            ),
          );
        },
      ),
      const SizedBox(width: 8),
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          foregroundColor: themeManager.colorStroke,
        ),
        child: Row(
          children: const [
            Icon(Icons.delete),
            SizedBox(width: 8),
            Text('Löschen'),
          ],
        ),
        onPressed: () {
          removeGrade(this);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const GradesScreen()),
          );
        },
      ),
    ];
  }

  Widget listTile(BuildContext context) {
    return ListTile(
      onTap: () => showMCGBottomSheet(context, title, _details, _actions(context)),
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

final List<int> gradeEntries = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

List<Grade> grades = [];

void sortGrades() {
  grades.sort((a, b) =>
      int.parse(DateFormat('yyyyMMdd').format(b.date)).compareTo(int.parse(DateFormat('yyyyMMdd').format(a.date))));
}

void addGrade(Grade grade) {
  grades.add(grade);
  sortGrades();
}

void removeGrade(Grade grade) {
  grades.remove(grade);
}

void editGrade(Grade before, Grade after) {
  grades.insert(grades.indexOf(before), after);
  grades.remove(before);
  sortGrades();
}
