import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mcgapp/classes/course.dart';

Map<String, Room> rooms = {};

class Room {
  late String number;
  late String name;
  late String teacher;
  late String type;
  late double startX;
  late double startY;
  late double endX;
  late double endY;

  Room({
    required this.number,
    required this.name,
    required this.teacher,
    required this.type,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });

  static Future<Map<String, Room>> getRooms() async {
    var jsonText = await rootBundle.loadString('assets/data/rooms.json');

    List data = json.decode(jsonText)['rooms'];
    Map<String, Room> rooms = {};
    for (int i = 0; i < data.length; i++) {
      Room room = Room.fromJson(data, i);
      rooms[room.number] = room;
    }

    return rooms;
  }

  Room.fromNumber(String number) {
    Room? room = rooms[number];

    this.number = room?.number ?? '0.00';
    name = room?.name ?? 'Unbekannter Raum';
    teacher = room?.teacher ?? '';
    type = room?.type ?? '';
    startX = room?.startX ?? 0;
    startY = room?.startY ?? 0;
    endX = room?.endX ?? 0;
    endY = room?.endY ?? 0;
  }

  static Room? fromTime(String time) {
    for (Course course in courses.values) {
      for (List<String> t in course.times) {
        if (t[0] == time) return Room.fromNumber(t[1]);
      }
    }
    return null;
  }

  Room.fromJson(var json, int index) {
    number = json[index]['number'];
    name = json[index]['name'];
    teacher = json[index]['teacher'] ?? '';
    type = json[index]['type'];
    startX = json[index]['startpos']['x'].toDouble();
    startY = json[index]['startpos']['y'].toDouble();
    endX = json[index]['endpos']['x'].toDouble();
    endY = json[index]['endpos']['y'].toDouble();
  }
}