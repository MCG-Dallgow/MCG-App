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
          ((title ?? '') == '') && ((actions ?? []) == [])
              ? Container()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Flexible(
                      child: Text(
                        title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Row(children: actions ?? []),
                  ]),
                ),
          ((title ?? '') == '') && ((actions ?? []) == []) ? Container() : const Divider(height: 4),
          body == null
              ? Container()
              : Column(
                  children: body,
                ),
        ],
      );
    },
  );
}
