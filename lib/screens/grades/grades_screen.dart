import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mcgapp/screens/grades/grade_edit_screen.dart';
import 'package:mcgapp/widgets/app_bar.dart';
import 'package:mcgapp/widgets/drawer.dart';

import '../../classes/course.dart';
import '../../classes/grade.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

final List<int> gradeEntries = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

final List<Course> courses = [
  Course(
    title: 'MaL11',
    displayName: 'Mathematik',
    short: 'Mat',
    color: Colors.blue.shade900,
  ),
  Course(
    title: 'EnG11_2',
    displayName: 'Englisch',
    short: 'Eng',
    color: Colors.deepOrange.shade800,
  ),
];

List<Grade> grades = [
  Grade(
    title: 'Test Ableitungen',
    course: courses[0],
    grade: 15,
    format: GradeFormat.format15,
    date: DateTime(2022, 10, 20),
    type: GradeType.test,
  ),
  Grade(
    title: 'Essay "Aims and Ambitions"',
    course: courses[1],
    grade: 14,
    format: GradeFormat.format15,
    date: DateTime(2022, 10, 11),
    type: GradeType.test,
  ),
];

void addGrade(Grade grade) {
  grades.add(grade);
}

void removeGrade(Grade grade) {
  grades.remove(grade);
}

void editGrade(Grade before, Grade after) {
  grades.insert(grades.indexOf(before), after);
  grades.remove(before);
}

class _GradesScreenState extends State<GradesScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('de_DE');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(
        title: 'Noten',
      ),
      drawer: const MCGDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const GradeEditScreen();
            }),
          );
        },
      ),
      body: ListView.builder(
        itemCount: grades.length * 2,
        itemBuilder: (BuildContext context, int index) {
          if (index.isOdd) return const Divider();

          Grade grade = grades[index ~/ 2];
          return grade.listTile(context);
        },
      ),
    );
  }
}
