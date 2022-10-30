import 'package:flutter/material.dart';
import 'package:mcgapp/widgets/app_bar.dart';

import '../../classes/course.dart';
import '../../classes/grade.dart';
import 'grade_edit_screen.dart';

class CourseGradesScreen extends StatefulWidget {
  const CourseGradesScreen({
    Key? key,
    required this.course,
  }) : super(key: key);

  final Course course;

  @override
  State<CourseGradesScreen> createState() => _CourseGradesScreenState();
}

class _CourseGradesScreenState extends State<CourseGradesScreen> {
  Widget _body = const Center(child: Text('Wird geladen...'));

  _updateBody() async {
    await loadGrades();
    setState(() {
      _body = ListView.builder(
        itemCount: widget.course.courseGrades.length * 2,
        itemBuilder: (BuildContext context, int index) {
          if (index.isOdd) return const Divider();

          Grade grade = widget.course.courseGrades[index ~/ 2];
          return grade.listTile(context);
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
    return Scaffold(
      appBar: MCGAppBar(
        title: widget.course.displayName,
        color: widget.course.color,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.course.gradeAverage == -1 ? '/' : 'Ø${widget.course.gradeAverage}',
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
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return GradeEditScreen(course: widget.course, returnToScreen: CourseGradesScreen(course: widget.course));
            }),
          );
          if (!mounted) return;
          _updateBody();
        },
      ),
      body: _body,
    );
  }
}
