import 'package:flutter/material.dart';
import 'package:mcgapp/widgets/app_bar.dart';

import '../../classes/course.dart';
import '../../classes/grade.dart';
import '../../main.dart';
import 'grade_edit_screen.dart';

class CourseGradesScreen extends StatefulWidget {
  const CourseGradesScreen({Key? key}) : super(key: key);

  static const routeName = '/grades/courses';

  @override
  State<CourseGradesScreen> createState() => _CourseGradesScreenState();
}

class _CourseGradesScreenState extends State<CourseGradesScreen> {
  Widget _body = const Center(child: Text('Wird geladen...'));

  late Course course;

  _updateBody() async {
    await loadGrades();
    setState(() {
      _body = ListView.builder(
        itemCount: course.courseGrades.length * 2,
        itemBuilder: (BuildContext context, int index) {
          if (index.isOdd) return const Divider();

          Grade grade = course.courseGrades[index ~/ 2];
          return grade.listTile(context, <Widget>[
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
              onPressed: () async {
                Navigator.pop(context);
                await Navigator.pushNamed(
                  context,
                  GradeEditScreen.routeName,
                  arguments: {'grade': grade},
                ).then((newGrade) { if (newGrade != null) editGrade(grade, newGrade as Grade); });

                if (!mounted) return;
                _updateBody();
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
                removeGrade(grade);
                Navigator.pop(context);
                _updateBody();
              },
            ),
          ]);
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _updateBody();
  }

  @override
  Widget build(BuildContext context) {
    course = ModalRoute.of(context)!.settings.arguments as Course;

    return Scaffold(
      appBar: MCGAppBar(
        title: course.displayName,
        backgroundColor: course.backgroundColor,
        foregroundColor: course.foregroundColor,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                course.gradeAverage == -1 ? '/' : 'Ø${course.gradeAverage}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Neue Note'),
        icon: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            GradeEditScreen.routeName,
            arguments: {'course': course},
          ).then((newGrade) { if (newGrade != null) addGrade(newGrade as Grade); });

          if (!mounted) return;
          _updateBody();
        },
      ),
      body: _body,
    );
  }
}
