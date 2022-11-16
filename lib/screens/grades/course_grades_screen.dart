import 'package:flutter/material.dart';

import '../../classes/course.dart';
import '../../classes/grade.dart';
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
    await Grade.loadGrades();
    setState(() {
      _body = course.courseGrades.isEmpty
          ? const Center(child: Text('Keine Noten in diesem Fach'))
          : ListView.builder(
              itemCount: course.courseGrades.length * 2 + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == course.courseGrades.length * 2) return const SizedBox(height: 76);
                if (index.isOdd) return const Divider();

                Grade grade = course.courseGrades[index ~/ 2];
                return grade.listTile(context, <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () async {
                      Navigator.pop(context);
                      await Navigator.pushNamed(
                        context,
                        GradeEditScreen.routeName,
                        arguments: {'grade': grade},
                      ).then((newGrade) {
                        if (newGrade != null) Grade.editGrade(grade, newGrade as Grade);
                      });

                      if (!mounted) return;
                      _updateBody();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      Grade.removeGrade(grade);
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
      appBar: AppBar(
        title: Text(course.subject.title),
        backgroundColor: course.subject.backgroundColor,
        foregroundColor: course.subject.foregroundColor,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                course.gradeAverage == -1 ? '/' : 'Ø${course.gradeAverage.toStringAsFixed(2)}',
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
          ).then((newGrade) {
            if (newGrade != null) Grade.addGrade(newGrade as Grade);
          });

          if (!mounted) return;
          _updateBody();
        },
      ),
      body: _body,
    );
  }
}
