import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/course.dart';
import 'package:mcgapp/classes/grade.dart';
import 'package:mcgapp/screens/grades/grades_screen.dart';
import 'package:mcgapp/widgets/app_bar.dart';

class GradeEditScreen extends StatefulWidget {
  const GradeEditScreen({Key? key}) : super(key: key);

  @override
  State<GradeEditScreen> createState() => _GradeEditScreenState();
}

class _GradeEditScreenState extends State<GradeEditScreen> {
  static DateFormat format = DateFormat('EEEE, d. MMMM yyyy', 'de');
  late TextEditingController dateController;

  String? _title;
  Course? _course;
  int? _gradeValue;
  final GradeFormat _gradeFormat = GradeFormat.format15;
  DateTime? _date;
  GradeType? _type;

  String test = 'Neue Note';

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
              title: Text(course.displayName),
              leading: course.circleAvatar,
              onTap: () {
                setState(() {
                  _course = course;
                });
                Navigator.of(context).pop();
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
          itemCount: gradeEntries.length,
          itemBuilder: (BuildContext context, int index) {
            //if (index.isOdd) return const Divider();

            return ListTile(
              title: Text(gradeEntries[index].toString()),
              leading: const Icon(Icons.star),
              onTap: () {
                setState(() {
                  _gradeValue = gradeEntries[index];
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
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2023),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('de_DE');
    dateController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: test),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Fertig'),
        icon: const Icon(Icons.done),
        onPressed: () {
          if (_title == null || _title == '') {
            setState(() {
              test = 'Fehler';
            });
          } else {
            grades.add(Grade(
              title: _title!,
              course: _course!,
              grade: _gradeValue!,
              format: _gradeFormat,
              date: _date!,
              type: _type ?? GradeType.test,
            ));
            Navigator.pop(context);
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
              onChanged: (text) => setState(() {
                _title = text;
              }),
            ),
          ),
          const Divider(),
          ListTile(
            title: _course == null ? const Text('Kurs') : Text(_course!.displayName),
            leading: _course == null ? const Icon(Icons.widgets) : _course?.circleAvatar,
            onTap: () => _showCourseSelectionBottonSheet(context),
          ),
          const Divider(),
          ListTile(
            title: _gradeValue == null ? const Text('Note: -'): Text("Note: $_gradeValue"),
            leading: const Icon(Icons.star),
            onTap: () => _showGradeSelectionBottonSheet(context),
          ),
          const Divider(),
          ListTile(
            title: TextField(
              controller: dateController,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Datum'),
              //enabled: false,
            ),
            leading: const Icon(Icons.calendar_today),
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
