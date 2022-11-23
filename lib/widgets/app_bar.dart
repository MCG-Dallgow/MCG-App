import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));
  final double? toolbarHeight;
  final double? bottomHeight;
}

class MCGAppBar extends StatelessWidget implements PreferredSizeWidget {
  MCGAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.bottom,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
  }) : preferredSize = _PreferredAppBarSize(kToolbarHeight, bottom?.preferredSize.height),
        super(key: key);

  final Widget title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      titleTextStyle: kIsWeb ? null : const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      centerTitle: true,
      bottom: bottom,
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}
