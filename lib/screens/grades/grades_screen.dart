import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mcgapp/screens/grades/course_grades_screen.dart';
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

class _GradesScreenState extends State<GradesScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('de_DE');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: 'Noten',
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('Alle')),
              Tab(child: Text('Fächer')),
            ],
          ),
        ),
        drawer: const MCGDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Neue Note'),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const GradeEditScreen();
              }),
            );
          },
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: grades.length * 2,
              itemBuilder: (BuildContext context, int index) {
                if (index.isOdd) return const Divider();

                Grade grade = grades[index ~/ 2];
                return grade.listTile(context);
              },
            ),
            ListView.builder(
              itemCount: courses.length,
              itemBuilder: (BuildContext context, int index) {
                Course course = courses[index];
                return ListTile(
                  title: Text(course.displayName),
                  leading: course.circleAvatar,
                  trailing: Text(
                    course.gradeAverage == -1 ? '/' : 'Ø${course.gradeAverage}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => CourseGradesScreen(course: course)),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
