import 'package:flutter/material.dart';

class MenuItem {
  final String tooltip;
  final IconData iconData;
  final Color iconColor;
  final double width;
  final Function()? onTap;
  MenuItem({
    required this.tooltip,
    required this.iconData,
    required this.iconColor,
    required this.width,
    this.onTap,
  });
}
