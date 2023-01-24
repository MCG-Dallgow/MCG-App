import 'package:dio/dio.dart';
import 'package:mcgapp/classes/timetable_entry.dart';
import 'package:mcgapp/classes/user.dart';
import 'package:mcgapp/enums/group.dart';

import '../classes/course.dart';
import '../classes/room.dart';
import '../classes/teacher.dart';
import '../enums/subject.dart';
import '../main.dart';

class API {
  static final dio = Dio();

  static Future<String> signup(String username, String encryptedPassword) async {
    try {
      await dio.post(
        '$apiBaseURL/auth/signup',
        options: Options(headers: {
          'username': username,
          'encrypted_password': encryptedPassword,
        }),
      );
      return 'success';
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 403:
          return 'invalid credentials';
        case 409:
          return 'user exists';
        default:
          return 'error';
      }
    }
  }

  static Future<String> login(String username, String encryptedPassword) async {
    try {
      var response = await dio.post(
        '$apiBaseURL/auth/login',
        options: Options(headers: {
          'username': username,
          'encrypted_password': encryptedPassword,
        }),
      );
      var data = response.data;

      AppUser user = AppUser(
        username: username,
        password: encryptedPassword,
        firstname: data['firstname'],
        lastname: data['lastname'],
        group: Group.fromName(data['group'])!,
      );

      AppUser.saveUser(user);

      return 'success';
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 403:
          return 'invalid credentials';
        case 404:
          return 'user does not exist';
        default:
          return 'error';
      }
    }
  }

  static Future<Map<String, Course>> getCourses() async {
    var response = await dio.get(
      '$apiBaseURL/user/courses',
      options: Options(headers: {
        'username': AppUser.user!.username,
        'encrypted_password': AppUser.user!.password,
      }),
    );
    Map<String, dynamic> data = response.data;
    Map<String, Course> courses = {};
    for (Map<String, dynamic> course in data.values) {
      courses[course['name']] = Course(
        name: course['name'],
        subject: Subject.fromShort(course['subject']),
        teacher: Teacher.fromShort(course['teacher']),
        rooms: (course['rooms'] as List<dynamic>).map((e) => Room.fromNumber(e as String)).toList(),
      );
    }

    return courses;
  }

  static Future<Map<String, Map<String, List<RegularTimetableEntry>>>> getRegularTimetable() async {
    var response = await dio.get(
      '$apiBaseURL/user/reg_timetable',
      options: Options(headers: {
        'username': AppUser.user!.username,
        'encrypted_password': AppUser.user!.password,
      }),
    );
    var data = response.data;

    Map<String, Map<String, List<RegularTimetableEntry>>> timetable = {};
    for (String week in data.keys) {
      timetable[week] = {};
      for (String day in data[week].keys) {
        timetable[week]![day] = [];
        for (Map<String, dynamic> lesson in data[week][day]) {
          timetable[week]![day]!.add(RegularTimetableEntry(
            week: week,
            weekday: int.parse(day),
            start: lesson['start'],
            end: lesson['end'],
            lesson: lesson['lesson'],
            course: Course.fromName(lesson['course']),
            teacher: Teacher.fromShort(lesson['teacher']),
            room: Room.fromNumber(lesson['room']),
          ));
        }
      }
    }

    return timetable;
  }

  static Future<Map<DateTime, List<TimetableEntry>>> getTimetable(int start, int end) async {
    var response = await dio.get(
      '$apiBaseURL/user/timetable?start=$start&end=$end',
      options: Options(headers: {
        'username': AppUser.user!.username,
        'encrypted_password': AppUser.user!.password,
      }),
    );
    var data = response.data;

    Map<DateTime, List<TimetableEntry>> timetable = {};
    for (List<dynamic> entry in data.values) {
      DateTime date = DateTime.parse(entry[0]['date']);
      timetable[date] = [];
      for (Map<String, dynamic> lesson in entry) {
        timetable[date]!.add(TimetableEntry(
          date: date,
          start: lesson['start'],
          end: lesson['end'],
          lesson: lesson['lesson'],
          course: Course.fromName(lesson['course']),
          regTeacher: Teacher.fromShort(lesson['reg_teacher']),
          subTeacher: Teacher.fromShort(lesson['sub_teacher']),
          regRoom: Room.fromNumber(lesson['reg_room']),
          subRoom: Room.fromNumber(lesson['sub_room']),
        ));
      }
    }

    return timetable;
  }
}
