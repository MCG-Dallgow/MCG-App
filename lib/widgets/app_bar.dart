import 'package:flutter/material.dart';

class MCGAppBar extends StatefulWidget implements PreferredSizeWidget {
  MCGAppBar({
    Key? key,
    required this.title,
    this.bottom}) :
        preferredSize = _PreferredAppBarSize(kToolbarHeight, bottom?.preferredSize.height),
        super(key: key);

  final String title;
  final PreferredSizeWidget? bottom;

  @override
  final Size preferredSize;

  @override
  State<MCGAppBar> createState() => _MCGAppBarState();
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class _MCGAppBarState extends State<MCGAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      bottom: widget.bottom,
      backgroundColor: Colors.blueGrey,
      actions: [
        /*IconButton(
          icon: Icon(/*isThemeDark ? */Icons.dark_mode/* : Icons.light_mode*/),
          onPressed: () {/*
            setState(() {
              isThemeDark = !isThemeDark;
            });
          */},
        ),*/
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () { },
        )
      ],
    );
  }
}
