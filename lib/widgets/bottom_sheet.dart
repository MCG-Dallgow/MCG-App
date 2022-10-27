import 'package:flutter/material.dart';

void showMCGBottomSheet(BuildContext context, String? title, List<Widget>? body, List<Widget>? actions) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    builder: (BuildContext context) {
      return Wrap(
        children: [
          title == null
              ? Container()
              : ListTile(
                  title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
          body == null
              ? Container()
              : Column(
                  children: body,
                ),
          const SizedBox(height: 32),
          actions == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions,
                ),
        ],
      );
    },
  );
}
