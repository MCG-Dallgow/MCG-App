import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mcgapp/screens/grades/course_grades_screen.dart';
import 'package:mcgapp/screens/grades/grade_edit_screen.dart';
import 'package:mcgapp/widgets/app_bar.dart';
import 'package:mcgapp/widgets/drawer.dart';

import '../../classes/course.dart';
import '../../classes/grade.dart';
import '../../main.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  static const routeName = '/grades';

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  TabBarView _tabBarView = const TabBarView(children: [
    Center(child: Text('Wird geladen...')),
    Center(child: Text('Wird geladen...')),
  ]);

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('de_DE');
    _updateBody();
  }

  _updateBody() async {
    await loadGrades();
    setState(() {
      _tabBarView = TabBarView(
        children: [
          ListView.builder(
            itemCount: grades.length * 2 + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == grades.length * 2) return const SizedBox(height: 76);
              if (index.isOdd) return const Divider();

              Grade grade = grades[index ~/ 2];
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
                    ).then((newGrade) {
                      if (newGrade != null) editGrade(grade, newGrade as Grade);
                    });

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
          ),
          ListView.builder(
            itemCount: courses.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == courses.length) return const SizedBox(height: 76);

              Course course = courses[index];
              return ListTile(
                title: Text(course.displayName),
                leading: course.circleAvatar,
                trailing: Text(
                  course.gradeAverage == -1 ? '/' : 'Ø${course.gradeAverage.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CourseGradesScreen.routeName,
                    arguments: course,
                  ).then((value) => _updateBody());
                },
              );
            },
          ),
        ],
      );
    });
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
        drawer: const MCGDrawer(routeName: GradesScreen.routeName),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Neue Note'),
          icon: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              GradeEditScreen.routeName,
            ).then((newGrade) {
              if (newGrade != null) addGrade(newGrade as Grade);
            });

            if (!mounted) return;
            _updateBody();
          },
        ),
        body: _tabBarView,
      ),
    );
  }
}
