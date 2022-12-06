import 'package:flutter/material.dart';
import 'package:mcgapp/main.dart';

showConfirmationDialog(BuildContext context, String title, String content, String no, String yes, dynamic action) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(no, style: TextStyle(color: themeManager.colorStroke)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: action,
            child: Text(yes),
          ),
        ],
      );
    },
  );
}
