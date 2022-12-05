import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mcgapp/screens/grades/course_grades_screen.dart';
import 'package:mcgapp/screens/grades/grade_edit_screen.dart';
import 'package:mcgapp/widgets/confirmation_dialog.dart';
import 'package:mcgapp/widgets/drawer.dart';

import '../../classes/course.dart';
import '../../classes/grade.dart';
import '../../widgets/app_bar.dart';

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
    Center(child: Text('Wird geladen...')),
  ]);

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('de_DE');
    _updateBody();
  }

  _updateBody() async {
    await Grade.loadGrades();
    setState(() {
      _tabBarView = TabBarView(
        children: [
          Grade.grades.isEmpty
              ? const Center(child: Text('Keine Noten'))
              : ListView.builder(
                  itemCount: Grade.grades.length * 2 + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == Grade.grades.length * 2) return const SizedBox(height: 76);
                    if (index.isOdd) return const Divider();

                    Grade grade = Grade.grades[index ~/ 2];
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
                          showConfirmationDialog(
                            context,
                            'Löschen',
                            '',
                            'ABBRECHEN',
                            'LÖSCHEN',
                            () {
                              Grade.removeGrade(grade);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              _updateBody();
                            },
                          );
                        },
                      ),
                    ]);
                  },
                ),
          ListView.builder(
            itemCount: userCourses.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == userCourses.length) return const SizedBox(height: 76);

              Course course = userCourses[index];
              return ListTile(
                title: Text(course.subject.name),
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
          const Center(child: Text('Coming Soon')),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: MCGAppBar(
          title: const Text('Noten'),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  Grade.totalAverage == -1 ? '/' : 'Ø${Grade.totalAverage.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('Alle')),
              Tab(child: Text('Fächer')),
              Tab(child: Text('Auswertung')),
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
              if (newGrade != null) Grade.addGrade(newGrade as Grade);
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
