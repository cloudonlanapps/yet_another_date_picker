import 'package:flutter/material.dart';

class ItemView extends StatelessWidget {
  const ItemView({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.textStyle,
  }) : super(key: key);

  final String label;
  final Color backgroundColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(1.0),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: textStyle,
          ),
        ));
  }
}
