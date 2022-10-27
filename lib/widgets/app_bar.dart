import 'package:flutter/material.dart';

class MCGAppBar extends StatelessWidget implements PreferredSizeWidget {
  MCGAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.bottom,
    this.color}) :
        preferredSize = _PreferredAppBarSize(kToolbarHeight, bottom?.preferredSize.height),
        super(key: key);

  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? color;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: bottom,
      actions: actions,
      backgroundColor: color,
    );
  }
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}
