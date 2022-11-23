import 'package:flutter/material.dart';

import '../classes/course.dart';

Future<List<Course>> showCourseChoosingDialog(BuildContext context) async {
  List<Course> courses = await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const _CourseChoosingDialog();
    },
  );
  return courses;
}

class _CourseChoosingDialog extends StatefulWidget {
  const _CourseChoosingDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<_CourseChoosingDialog> createState() => _CourseChoosingDialogState();
}

class _CourseChoosingDialogState extends State<_CourseChoosingDialog> {
  final List<Course> _selectedCourses = userCourses;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        title: const Text('Wähle deine Kurse'),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (BuildContext context, int index) {
                    Course course = courses.values.toList()[index];
                    return CheckboxListTile(
                      title: Row(children: [
                        Text(course.title),
                        Flexible(
                          child: Text(
                            ' (${course.teacher.nachname})',
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                      value: _selectedCourses.contains(course),
                      onChanged: (var value) {
                        if (value ?? false) {
                          if (!_selectedCourses.contains(course)) {
                            setState(() {
                              _selectedCourses.add(course);
                            });
                          }
                        } else {
                          if (_selectedCourses.contains(course)) {
                            setState(() {
                              _selectedCourses.remove(course);
                            });
                          }
                        }
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: _selectedCourses.isEmpty ? Colors.grey : null),
                        onPressed: () {
                          if (_selectedCourses.isNotEmpty) {
                            setState(() {
                              _selectedCourses.clear();
                            });
                          }
                        },
                        child: const Text('Leeren'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: _selectedCourses.isEmpty ? Colors.grey : null),
                        onPressed: () {
                          if (_selectedCourses.isNotEmpty) {
                            setUserCourses(_selectedCourses);
                            Navigator.pop(context, _selectedCourses);
                          }
                        },
                        child: const Text('Fertig'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
