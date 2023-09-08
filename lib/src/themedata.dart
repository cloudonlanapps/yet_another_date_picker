import 'package:flutter/material.dart';

class DateSelectorThemeData {
  final Color backgroundColor;

  final Color backgroundColorDisabled;
  final TextStyle textStyle;
  final TextStyle textStyleSelected;
  final TextStyle textStyleDisabled;
  final Color iconColor;

  DateSelectorThemeData({
    Color? backgroundColor,
    Color? backgroundColorSelected,
    Color? backgroundColorDisabled,
    TextStyle? textStyle,
    TextStyle? textStyleSelected,
    TextStyle? textStyleDisabled,
    Color? iconColor,
  })  : backgroundColor = backgroundColor ?? Colors.white,
        backgroundColorDisabled = Colors.grey.shade100,
        textStyle = textStyle ?? const TextStyle(),
        textStyleSelected = textStyleSelected ??
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        textStyleDisabled =
            textStyleDisabled ?? const TextStyle(color: Colors.grey),
        iconColor = iconColor ?? Colors.blue;
}
