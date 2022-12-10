import 'package:flutter/material.dart';
import 'package:mcgapp/enums/grade_type.dart';

import '../../classes/course.dart';
import '../../classes/grade.dart';
import '../../main.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/confirmation_dialog.dart';
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
      List<int> typesWithGrades = course.gradeTypes.keys
          .where((typeId) => course.courseGrades.where((grade) => grade.type.id == typeId).isNotEmpty)
          .toList();
      typesWithGrades.sort((a, b) => b.compareTo(a));

      _body = course.courseGrades.isEmpty
          ? const Center(child: Text('Keine Noten in diesem Fach'))
          : ListView.builder(
              itemCount: typesWithGrades.length * 2 + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == typesWithGrades.length * 2) return const SizedBox(height: 76);
                int typeId = typesWithGrades[index ~/ 2];
                List<Grade> typeGrades = course.courseGrades.where((e) => e.type.id == typeId).toList();

                if (index.isEven) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      GradeType.getTypeName(typeId),
                      style: TextStyle(
                        fontSize: 16,
                        color: themeManager.themeMode == ThemeMode.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  );
                }

                return Column(
                    children: typeGrades
                        .map((e) => e.listTile(context, <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.grey),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await Navigator.pushNamed(
                                    context,
                                    GradeEditScreen.routeName,
                                    arguments: {'grade': e},
                                  ).then((newGrade) {
                                    if (newGrade != null) Grade.editGrade(e, newGrade as Grade);
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
                                      Grade.removeGrade(e);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      _updateBody();
                                    },
                                  );
                                },
                              ),
                            ]))
                        .toList());
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
        title: Text(course.subject.name, style: TextStyle(color: course.subject.foregroundColor)),
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
