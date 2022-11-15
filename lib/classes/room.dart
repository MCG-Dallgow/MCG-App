import 'dart:convert';

import 'package:flutter/services.dart';

class Room {
  late String number;
  late String name;
  late String teacher;
  late String image;
  late String type;
  late double startX;
  late double startY;
  late double endX;
  late double endY;

  Room({
    required this.number,
    required this.name,
    required this.teacher,
    required this.image,
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

  Room.fromJson(var json, int index) {
    number = json[index]['number'];
    name = json[index]['name'];
    teacher = json[index]['teacher'];
    image = json[index]['image'];
    type = json[index]['type'];
    startX = json[index]['startpos']['x'];
    startY = json[index]['startpos']['y'];
    endX = json[index]['endpos']['x'];
    endY = json[index]['endpos']['y'];
  }
}