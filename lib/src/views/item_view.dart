import 'dart:math';

import 'package:flutter/material.dart';

class ItemView extends StatelessWidget {
  const ItemView({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.textStyle,
    required this.height,
    required this.width,
    required this.alignment,
  }) : super(key: key);

  final String label;
  final double height;
  final double width;
  final Color backgroundColor;
  final TextStyle textStyle;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
          color: backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(2.0),
            ),
          ),
          child: Align(
            alignment: alignment,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: max(height * 0.02, 1.0),
                  horizontal: max(width * 0.02, 1.0)),
              child: Text(
                label,
                style: textStyle,
              ),
            ),
          )),
    );
  }
}
