import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/widgets/bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/grade_type.dart';
import 'course.dart';

enum GradeFormat { format15, format6 }

class Grade {
  static List<Grade> _grades = [];
  static final List<int> _gradeEntriesSekI = [1, 2, 3, 4, 5, 6];
  static final List<int> _gradeEntriesSekII = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

  static List<Grade> get grades => _grades;
  static List<int> get gradeEntries {
    if (group!.level > 10) return _gradeEntriesSekII;
    return _gradeEntriesSekI;
  }

  static double get totalAverage {
    List<Course> coursesWithGrades = userCourses.where((e) => e.gradeAverage != -1).toList();
    if (coursesWithGrades.isEmpty) return -1;

    double sum = 0;
    for (Course course in coursesWithGrades) {
      sum += course.gradeAverage;
    }

    return sum / coursesWithGrades.length;
  }

  static void sortGrades() {
    grades.sort((a, b) =>
        int.parse(DateFormat('yyyyMMdd').format(b.date)).compareTo(int.parse(DateFormat('yyyyMMdd').format(a.date))));
  }

  static void addGrade(Grade grade) {
    grades.add(grade);
    sortGrades();
    saveGrades();
  }

  static void removeGrade(Grade grade) {
    grades.remove(grade);
    saveGrades();
  }

  static void editGrade(Grade before, Grade after) {
    grades.insert(grades.indexOf(before), after);
    grades.remove(before);
    sortGrades();
    saveGrades();
  }

  static Future<void> saveGrades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedGrades = [];
    for (Grade grade in grades) {
      encodedGrades.add('${grade.title}|${grade.course.title}|${grade.grade}|'
                        '${DateFormat('yyyy-MM-dd').format(grade.date)}|${grade.type}');
    }
    prefs.setStringList('grades', encodedGrades);
  }

  static Future<void> loadGrades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedGrades = prefs.getStringList('grades') ?? [];
    List<Grade> decodedGrades = [];
    for (String encodedGrade in encodedGrades) {
      List<String> gradeParameters = encodedGrade.split('|');
      decodedGrades.add(Grade(
        title: gradeParameters[0],
        course: Course.fromTitle(gradeParameters[1]),
        format: GradeFormat.format15,
        grade: int.parse(gradeParameters[2]),
        date: DateTime.parse(gradeParameters[3]),
        type: GradeType.fromName(gradeParameters[4]),
      ));
    }
    _grades = decodedGrades;
  }

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
          color: course.subject.backgroundColor,
        ),
        title: Text('${course.subject.name} (${course.title})'),
      ),
      ListTile(
        leading: const Icon(Icons.star),
        title: Text('$grade'),
      ),
      ListTile(
        leading: const Icon(Icons.event),
        title: Text(DateFormat('EEEE, d. MMMM yyyy', 'de').format(date)),
      ),
      ListTile(
        leading: type.icon,
        title: Text(type.name),
      ),
    ];
  }

  Widget listTile(BuildContext context, List<Widget> actions) {
    return ListTile(
      onTap: () => showMCGBottomSheet(context, title, _details, actions),
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
            course.subject.name,
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
      leading: course.circleAvatar,
      trailing: Text(
        '$grade',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
