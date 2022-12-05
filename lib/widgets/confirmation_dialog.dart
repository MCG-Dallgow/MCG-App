import 'package:flutter/material.dart';

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
            child: Text(no, style: const TextStyle(color: Colors.white)),
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
