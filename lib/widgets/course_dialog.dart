import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/course.dart';

Future<void> chooseCourses(BuildContext context) async {
  userCourses = await _showCourseChoosingDialog(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('courses-${group!.name}', userCourses.map((course) => course.title).toList());
}

Future<List<Course>> _showCourseChoosingDialog(BuildContext context) async {
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
  final List<Course> _requiredCourses = [];

  @override
  void initState() {
    super.initState();
    for (Course course in courses.values) {
      if (course.required) _requiredCourses.add(course);
    }
    _selectedCourses.addAll(_requiredCourses);
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        title: Text('Wähle deine ${group!.level > 10 ? 'Kurse' : 'Fächer'}'),
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
                      enabled: !course.required,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Row(children: [
                        Text(group!.level > 10 ? course.title : course.subject.name),
                        Flexible(
                          child: Text(
                            ' (${course.teacher.lastname})',
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
                              _selectedCourses.addAll(_requiredCourses);
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
                            _selectedCourses.sort((a, b) => a.title.compareTo(b.title));
                            Navigator.pop(context, _selectedCourses.toSet().toList());
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
