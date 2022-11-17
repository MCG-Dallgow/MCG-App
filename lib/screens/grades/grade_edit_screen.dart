import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/course.dart';
import 'package:mcgapp/classes/grade.dart';

import '../../widgets/app_bar.dart';

class GradeEditScreen extends StatefulWidget {
  const GradeEditScreen({Key? key}) : super(key: key);

  static const routeName = '/grades/edit';

  @override
  State<GradeEditScreen> createState() => _GradeEditScreenState();
}

class _GradeEditScreenState extends State<GradeEditScreen> {
  static DateFormat format = DateFormat('EEEE, d. MMMM yyyy', 'de');
  late TextEditingController titleController;
  late TextEditingController dateController;

  bool fistChange = true;

  String? _title;
  Course? _course;
  int? _gradeValue;
  final GradeFormat _gradeFormat = GradeFormat.format15;
  DateTime? _date;
  GradeType? _type;

  _showCourseSelectionBottonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: courses.length * 2,
          itemBuilder: (BuildContext context, int index) {
            if (index.isOdd) return const Divider();

            Course course = courses[index ~/ 2];
            return ListTile(
              title: Text(course.subject.title),
              leading: course.circleAvatar,
              onTap: () {
                setState(() {
                  _course = course;
                });
                Navigator.pop(context, '');
              },
            );
          },
        );
      },
    );
  }

  _showGradeSelectionBottonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: Grade.gradeEntries.length,
          itemBuilder: (BuildContext context, int index) {
            //if (index.isOdd) return const Divider();

            return ListTile(
              title: Text(Grade.gradeEntries[index].toString()),
              leading: const Icon(Icons.star),
              onTap: () {
                setState(() {
                  _gradeValue = Grade.gradeEntries[index];
                });
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) {
    DateTime now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('de_DE');
    dateController = TextEditingController(text: '');
    titleController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    Grade? grade = args?['grade'];

    if (fistChange) {
      _title = grade?.title;
      _course = grade?.course ?? args?['course'];
      _gradeValue = grade?.grade;
      _date = grade?.date;
      _type = grade?.type;

      if (_title != null) titleController.text = _title!;
      if (_date != null) dateController.text = format.format(_date!);

      fistChange = false;
    }

    return Scaffold(
      appBar: MCGAppBar(title: Text(grade == null ? 'Neue Note' : 'Note bearbeiten')),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Fertig'),
        icon: const Icon(Icons.done),
        onPressed: () {
          if (_title != null && _title != '' && _course != null && _gradeValue != null && _date != null) {
            Grade newGrade = Grade(
              title: _title!,
              course: _course!,
              grade: _gradeValue!,
              format: _gradeFormat,
              date: _date!,
              type: _type ?? GradeType.test,
            );

            Navigator.pop(context, newGrade);
          }
        },
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titel',
              ),
              controller: titleController,
              onChanged: (text) => setState(() {
                _title = text;
              }),
            ),
          ),
          const Divider(),
          ListTile(
            title: _course == null ? const Text('Kurs') : Text(_course!.subject.title),
            leading: _course == null ? const Icon(Icons.widgets) : _course?.circleAvatar,
            onTap: () => _showCourseSelectionBottonSheet(context),
          ),
          const Divider(),
          ListTile(
            title: _gradeValue == null ? const Text('Note: -') : Text('Note: $_gradeValue'),
            leading: const Icon(Icons.star),
            onTap: () => _showGradeSelectionBottonSheet(context),
          ),
          const Divider(),
          ListTile(
            title: AbsorbPointer(
              absorbing: true,
              child: TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Datum',
                  icon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            onTap: () async {
              DateTime? date = await _showDatePicker(context);
              if (date != null) {
                setState(() {
                  _date = date;
                });
                dateController.text = format.format(_date!);
              }
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
